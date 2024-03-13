#[cfg(test)]
mod tests {
    
    use starknet::class_hash::Felt252TryIntoClassHash;
    use starknet::ContractAddress;
    use starknet::contract_address_const;
    // import test utils
    const NAME: felt252 = 'test';
    const SYMBOL: felt252 = 'test';
    const SUPPLY: u256 = 2000000;

    trait SerializedAppend<T> {
        fn append_serde(ref self: Array<felt252>, value: T);
    }

    impl SerializedAppendImpl<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>> of SerializedAppend<T> {
        fn append_serde(ref self: Array<felt252>, value: T) {
            value.serialize(ref self);
        }
    }
    fn deploy(contract_class_hash: felt252, calldata: Array<felt252>) -> ContractAddress {
        let result = starknet::deploy_syscall(
            contract_class_hash.try_into().unwrap(), 0, calldata.span(), false
        );
        let (address, _) = result.unwrap();
        address
    }

    #[test]
    #[available_gas(30000000)]
    fn test_move() {
        let mut calldata: Array<felt252> = array![];
        let caller: ContractAddress = contract_address_const::<'OWNER'>();
        calldata.append_serde(NAME);
        calldata.append_serde(SYMBOL);
        calldata.append_serde(SUPPLY);
        calldata.append_serde(caller);


        println!("ERC20::TEST_CLASS_HASH defined within package mod works");
        let _ = deploy(dojo_starter::erc20::ERC20::TEST_CLASS_HASH.try_into().unwrap(), calldata.clone());

        println!("ERC20 from dep defined failed");
        let _ = deploy(openzeppelin::presets::erc20::ERC20::TEST_CLASS_HASH.try_into().unwrap(), calldata);
    }
}
