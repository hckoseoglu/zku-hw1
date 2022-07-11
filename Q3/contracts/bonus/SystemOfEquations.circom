pragma circom 2.0.3;

template Multiplier2() {
    signal input in1;
    signal input in2;
    signal output out;
    out <== in1 * in2;
 }

template binaryCheck () {
   signal input in;
   signal output out;

   in * (in-1) === 0;
   out <== in;
}

template AndN (N){
   //Declaration of signals and components.
   signal input in[N];
   signal output out;
   component mult[N-1];
   component binCheck[N];

   //Statements.
   for(var i = 0; i < N; i++){
       binCheck[i] = binaryCheck();
         binCheck[i].in <== in[i];
   }
   for(var i = 0; i < N-1; i++){
       mult[i] = Multiplier2();
   }
   mult[0].in1 <== binCheck[0].out;
   mult[0].in2 <== binCheck[1].out;
   for(var i = 0; i < N-2; i++){
       mult[i+1].in1 <== mult[i].out;
       mult[i+1].in2 <== binCheck[i+2].out;

   }
   out <== mult[N-2].out; 
}

// sum of all elements in a matrix
template matElemSum (m,n) {
    signal input a[m][n];
    signal output out;

    signal sum[m*n];
    sum[0] <== a[0][0];
    var idx = 0;
    
    for (var i=0; i < m; i++) {
        for (var j=0; j < n; j++) {
            if (idx > 0) {
                sum[idx] <== sum[idx-1] + a[i][j];
            }
            idx++;
        }
    }

    out <== sum[m*n-1];
}

template IsZero() {
    signal input in;
    signal output out;

    signal inv;

    inv <-- in!=0 ? 1/in : 0;

    out <== -in*inv +1;
    in*out === 0;
}



template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution

    // [bonus] insert your code here
    var global = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    component matElemSum[n];
    component isZeroes[n];
    component and = AndN(n);
    for(var i = 0; i < n; i++){
        matElemSum[i] = matElemSum(1,n + 1);
        for(var j = 0; j < n; j++){
           matElemSum[i].a[0][j] <== A[i][j] * x[j];
        }
        matElemSum[i].a[0][n] <== global - b[i];
        isZeroes[i] = IsZero();
        isZeroes[i].in <== matElemSum[i].out;
        and.in[i] <== isZeroes[i].out;
    }
    out <== and.out;
}

component main {public [A, b]} = SystemOfEquations(3);