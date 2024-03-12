#[cfg(test)]
mod tests {
    use starknet::class_hash::Felt252TryIntoClassHash;
    use starknet::ContractAddress;

    // import test utils
    use openzeppelin::presets::erc20::ERC20;
    const NAME: felt252 = 'test';
    const SYNBOL: felt252 = 'test';
    const SUPPLY: u256 = 2000000;
    fn deploy(contract_class_hash: felt252, calldata: Array<felt252>) -> ContractAddress {
        let (address, _) = starknet::deploy_syscall(
            contract_class_hash.try_into().unwrap(), 0, calldata.span(), false
        )
            .unwrap();
        address
    }

    #[test]
    #[available_gas(30000000)]
    fn test_move() {
        let mut calldata: Array<felt252> = array![];
        let caller = starknet::get_caller_address();

        NAME.serialize(ref calldata);
        SYNBOL.serialize(ref calldata);
        SUPPLY.serialize(ref calldata);
        caller.serialize(ref calldata);
        let erc20_contract_address = deploy(ERC20::TEST_CLASS_HASH.try_into().unwrap(), calldata);
    }
}
