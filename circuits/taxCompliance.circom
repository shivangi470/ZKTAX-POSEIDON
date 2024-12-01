pragma circom 2.0.0;

include "circomlib/poseidon.circom";

template ZKTax() {
    signal input tax_rate;
    signal input total_tax_paid;
    signal input public_hash;

    signal private input income;
    signal private input deductions;
    signal private input taxable_amount;
    signal private input tax_paid;

    signal calc_taxable_amount;
    signal calc_tax_paid;

    calc_taxable_amount <== income - deductions;
    enforce(calc_taxable_amount == taxable_amount);

    calc_tax_paid <== taxable_amount * tax_rate;
    enforce(calc_tax_paid == tax_paid);

    signal hash;
    hash = Poseidon([income, deductions, taxable_amount, tax_paid]);
    enforce(hash == public_hash);

    enforce(tax_paid == total_tax_paid);
}

component main = ZKTax();