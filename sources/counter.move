module publisher::counter{

    use std::signer;

    struct CounterHolder has key {
        count : u64
    }
    #[view]
    public fun get_count(addr:address):u64 acquires CounterHolder{
        assert!(exists<CounterHolder>(addr),0);
        *&borrow_global<CounterHolder>(addr).count
    }

    public entry fun bump(account : signer )acquires CounterHolder{
        let addr = signer::address_of(&account);//why cant we just use account as it is already an address
        if(!exists<CounterHolder>(addr)){//where have I inialised the vector
            move_to(&account, CounterHolder{count:0})
        }
        else{
            let old_count = borrow_global_mut<CounterHolder>(addr);
            old_count.count = old_count.count + 1;

        }

    }


}