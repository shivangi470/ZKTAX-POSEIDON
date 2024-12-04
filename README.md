### Full Sequence to Run ZKTax Circuit Using Poseidon Hash Function

Below is a streamlined step-by-step guide to implement, compile, and deploy the **ZKTax circuit**. It incorporates Poseidon for privacy, Groth16 for proof generation and verification, and uses snarkjs for end-to-end processing.

---

#### **1. Install Required Tools**
1. **Install Rust**:
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   source $HOME/.cargo/env
   ```

2. **Install Circom**:
   ```bash
   git clone https://github.com/iden3/circom.git
   cd circom
   cargo build --release
   export PATH=$PATH:$(pwd)/target/release
   ```

3. **Install snarkjs**:
   - Globally:
     ```bash
     npm install -g snarkjs
     ```
   - Or use npx:
     ```bash
     npm install snarkjs
     ```

---

#### **2. Write the ZKTax Circuit**
---

#### **3. Compile the Circuit**
```bash
circom circuits/taxCompliance.circom --r1cs --wasm --sym
```

This generates:
- `taxCompliance.r1cs`: Constraint system
- `taxCompliance.wasm`: WebAssembly file
- `taxCompliance.sym`: Symbols for debugging

---

#### **4. Powers of Tau Ceremony**
1. **Initialize Ceremony**:
   ```bash
   snarkjs powersoftau new bn128 12 ceremony_0000.ptau -v
   ```

2. **Contribute Entropy**:
   ```bash
   snarkjs powersoftau contribute ceremony_0000.ptau ceremony_0001.ptau --name="First Contributor" -v
   snarkjs powersoftau contribute ceremony_0001.ptau ceremony_0002.ptau --name="Second Contributor" -v
   ```

3. **Prepare Phase 2**:
   ```bash
   snarkjs powersoftau prepare phase2 ceremony_0002.ptau ceremony_final.ptau -v
   ```

4. **Verify Final File**:
   ```bash
   snarkjs powersoftau verify ceremony_final.ptau -v
   ```

---

#### **5. Setup Proving and Verification Keys**
1. **Setup Groth16 Proving Key**:
   ```bash
   snarkjs groth16 setup circuits/taxCompliance.r1cs ceremony_final.ptau setup_0000.zkey
   ```

2. **Contribute to ZKey**:
   ```bash
   snarkjs zkey contribute setup_0000.zkey setup_final.zkey --name="First Contributor" -v
   ```

3. **Verify ZKey**:
   ```bash
   snarkjs zkey verify circuits/taxCompliance.r1cs ceremony_final.ptau setup_final.zkey -v
   ```

4. **Export Verification Key**:
   ```bash
   snarkjs zkey export verificationkey setup_final.zkey verification_key.json
   ```

---

#### **6. Generate Proof**
1. **Create Input JSON**:
 

2. **Generate Witness**:
   ```bash
   node circuits/taxCompliance_js/generate_witness.js circuits/taxCompliance_js/taxCompliance.wasm inputs.json witness.wtns
   ```

3. **Generate Proof**:
   ```bash
   snarkjs groth16 prove setup_final.zkey witness.wtns proof.json public.json
   ```

---

#### **7. Verify Proof**
1. **Verify Locally**:
   ```bash
   snarkjs groth16 verify verification_key.json public.json proof.json
   ```

2. **Export Solidity Verifier**:
   ```bash
   snarkjs zkey export solidityverifier setup_final.zkey verifier.sol
   ```

3. **Export Calldata**:
   ```bash
   snarkjs zkey export soliditycalldata public.json proof.json
   ```

---

#### **8. Deploy and Test On-Chain**
1. **Deploy Verifier Contract**:
   - Use `verifier.sol` on **Remix IDE** or any preferred Ethereum IDE.

2. **Submit Proof for Verification**:
   - Pass the calldata to the verifier smart contract function.

---

#### **9. Optional Debugging**
- **Debug Witness**:
   ```bash
   snarkjs wtns debug circuits/taxCompliance_js/taxCompliance.wasm witness.wtns circuits/taxCompliance.sym
   ```

- **Export Witness for Analysis**:
   ```bash
   snarkjs wtns export json witness.wtns witness.json
   ```


