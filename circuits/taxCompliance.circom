pragma circom 2.1.6;

include "../node_modules/circomlib/circuits/poseidon.circom";


template ZKTax() {
    signal input tax_rate;
    signal input total_tax_paid;
    signal input public_hash;

    signal input income;
    signal input deductions;
    signal input taxable_amount;
    signal input tax_paid;

    signal calc_taxable_amount;
    signal calc_tax_paid;

    // Calculate taxable amount
    calc_taxable_amount <== income - deductions;
    calc_taxable_amount === taxable_amount;

    // Calculate tax paid
    calc_tax_paid <== taxable_amount * tax_rate;
    calc_tax_paid === tax_paid;

    // Generate Poseidon hash
    signal computed_hash;  
    computed_hash <== Poseidon([income, deductions, taxable_amount, tax_paid]);

    computed_hash === public_hash;

    // Ensure total tax paid matches
    tax_paid === total_tax_paid;

}

component main = ZKTax();
