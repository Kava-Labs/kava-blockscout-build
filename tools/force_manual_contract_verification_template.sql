-- Step 1 Update Addresses table for contract
INSERT INTO public.addresses (fetched_coin_balance,fetched_coin_balance_block_number,hash,contract_code,inserted_at,updated_at,nonce,decompiled, verified, gas_used, transactions_count, token_transfers_count)
VALUES (
    0,
    5707619,
    decode('6df7bf308ABaf673f38Db316ECc97b988CE1Ca78', 'hex'),
	decode('608060405234801561001057600080fd5b50600436106100365760003560e01c806350f1c4641461003b578063c7aeef0f1461006a575b600080fd5b61004e6100493660046103b9565b61007d565b6040516001600160a01b03909116815260200160405180910390f35b61004e610078366004610407565b6100c3565b604080516001600160a01b038416602080830191909152818301849052825180830384018152606090920190925280519101206000906100bc9061014e565b9392505050565b6040805133602080830191909152818301869052825180830384018152606090920190925280519101206000906100fb90848461024a565b604080516001600160a01b03831681523360208201529081018690529091507fdcacc22833c6088cb24af3f735ee2744334a150babf878da84ecddbfcc77897e9060600160405180910390a19392505050565b604080518082018252601081526f67363d3d37363d34f03d5260086018f360801b60209182015290517fff00000000000000000000000000000000000000000000000000000000000000918101919091526bffffffffffffffffffffffff193060601b166021820152603581018290527f21c35dbe1b344a2488cf3321d6ce542f8e9f305544ff09e4993a62319a497c1f6055820152600090819061020a906075015b6040516020818303038152906040528051906020012090565b6040516135a560f21b60208201526bffffffffffffffffffffffff19606083901b166022820152600160f81b60368201529091506100bc906037016101f1565b6000806040518060400160405280601081526020016f67363d3d37363d34f03d5260086018f360801b81525090506000858251602084016000f590506001600160a01b0381166102e15760405162461bcd60e51b815260206004820152601160248201527f4445504c4f594d454e545f4641494c454400000000000000000000000000000060448201526064015b60405180910390fd5b6102ea8661014e565b92506000816001600160a01b0316858760405161030791906104cb565b60006040518083038185875af1925050503d8060008114610344576040519150601f19603f3d011682016040523d82523d6000602084013e610349565b606091505b5050905080801561036357506001600160a01b0384163b15155b6103af5760405162461bcd60e51b815260206004820152601560248201527f494e495449414c495a4154494f4e5f4641494c4544000000000000000000000060448201526064016102d8565b5050509392505050565b600080604083850312156103cc57600080fd5b82356001600160a01b03811681146103e357600080fd5b946020939093013593505050565b634e487b7160e01b600052604160045260246000fd5b60008060006060848603121561041c57600080fd5b83359250602084013567ffffffffffffffff8082111561043b57600080fd5b818601915086601f83011261044f57600080fd5b813581811115610461576104616103f1565b604051601f8201601f19908116603f01168101908382118183101715610489576104896103f1565b816040528281528960208487010111156104a257600080fd5b826020860160208301376000602084830101528096505050505050604084013590509250925092565b6000825160005b818110156104ec57602081860181015185830152016104d2565b50600092019182525091905056fea2646970667358221220e6b42f1072123a355b340beec30a0031a44f3e4e317b9a040b8e1ad386d6099a64736f6c63430008140033','hex'),
	now(),
	now(),
	null,
	false,
	true,
	null,
	0,
	0
)
ON CONFLICT (hash) DO UPDATE SET
fetched_coin_balance = EXCLUDED.fetched_coin_balance,
fetched_coin_balance_block_number = EXCLUDED.fetched_coin_balance_block_number,
hash = EXCLUDED.hash,
contract_code = EXCLUDED.contract_code,
inserted_at = EXCLUDED.inserted_at,
updated_at = EXCLUDED.updated_at,
nonce = EXCLUDED.nonce,
decompiled = EXCLUDED.decompiled,
verified = EXCLUDED.verified,
gas_used = EXCLUDED.gas_used,
transactions_count = EXCLUDED.transactions_count,
token_transfers_count = EXCLUDED.token_transfers_count;

-- Step 2 Update Address Names table for contract

INSERT INTO public.address_names (address_hash, name, "primary", inserted_at, updated_at)
VALUES (
  decode('6df7bf308ABaf673f38Db316ECc97b988CE1Ca78', 'hex'),
  'Create3Factory',
  true,
  now(),
  now()
)

# use below if contract data was already present in this table
UPDATE public.address_names
SET
name='Create3Factory',
"primary"=true,
inserted_at=now(),
updated_at=now
WHERE address_hash=decode('6df7bf308ABaf673f38Db316ECc97b988CE1Ca78', 'hex');

---- Step 3 Update Smart Contracts table for conract

INSERT INTO
  public.smart_contracts (
	  name,
	  compiler_version,
	  optimization,
	  contract_source_code,
	  abi,
	  address_hash,
	  inserted_at,
	  updated_at,
	  constructor_arguments,
	  optimization_runs,
	  evm_version,
	  verified_via_sourcify,
	  is_vyper_contract,
	  partially_verified,
	  file_path,
	  is_changed_bytecode
  )
VALUES (
'Create3Factory',
'v0.8.20+commit.a1b79de6',
true,
'// Sources flattened with hardhat v2.14.0 https://hardhat.org
\r\n
// File solmate/src/utils/Bytes32AddressLib.sol@v6.1.0
\r\n
// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;
\r\n
/// @notice Library for converting between addresses and bytes32 values.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/Bytes32AddressLib.sol)
library Bytes32AddressLib {
    function fromLast20Bytes(
        bytes32 bytesValue
    ) internal pure returns (address) {
        return address(uint160(uint256(bytesValue)));
    }
\r\n
    function fillLast12Bytes(
        address addressValue
    ) internal pure returns (bytes32) {
        return bytes32(bytes20(addressValue));
    }
}
\r\n
// File solmate/src/utils/CREATE3.sol@v6.1.0
\r\n
pragma solidity >=0.8.0;
\r\n
/// @notice Deploy to deterministic addresses without an initcode factor.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/CREATE3.sol)
/// @author Modified from 0xSequence (https://github.com/0xSequence/create3/blob/master/contracts/Create3.sol)
library CREATE3 {
    using Bytes32AddressLib for bytes32;
\r\n
    //--------------------------------------------------------------------------------//
    // Opcode     | Opcode + Arguments    | Description      | Stack View             //
    //--------------------------------------------------------------------------------//
    // 0x36       |  0x36                 | CALLDATASIZE     | size                   //
    // 0x3d       |  0x3d                 | RETURNDATASIZE   | 0 size                 //
    // 0x3d       |  0x3d                 | RETURNDATASIZE   | 0 0 size               //
    // 0x37       |  0x37                 | CALLDATACOPY     |                        //
    // 0x36       |  0x36                 | CALLDATASIZE     | size                   //
    // 0x3d       |  0x3d                 | RETURNDATASIZE   | 0 size                 //
    // 0x34       |  0x34                 | CALLVALUE        | value 0 size           //
    // 0xf0       |  0xf0                 | CREATE           | newContract            //
    //--------------------------------------------------------------------------------//
    // Opcode     | Opcode + Arguments    | Description      | Stack View             //
    //--------------------------------------------------------------------------------//
    // 0x67       |  0x67XXXXXXXXXXXXXXXX | PUSH8 bytecode   | bytecode               //
    // 0x3d       |  0x3d                 | RETURNDATASIZE   | 0 bytecode             //
    // 0x52       |  0x52                 | MSTORE           |                        //
    // 0x60       |  0x6008               | PUSH1 08         | 8                      //
    // 0x60       |  0x6018               | PUSH1 18         | 24 8                   //
    // 0xf3       |  0xf3                 | RETURN           |                        //
    //--------------------------------------------------------------------------------//
    bytes internal constant PROXY_BYTECODE =
        hex"67_36_3d_3d_37_36_3d_34_f0_3d_52_60_08_60_18_f3";
\r\n
    bytes32 internal constant PROXY_BYTECODE_HASH = keccak256(PROXY_BYTECODE);
\r\n
    function deploy(
        bytes32 salt,
        bytes memory creationCode,
        uint256 value
    ) internal returns (address deployed) {
        bytes memory proxyChildBytecode = PROXY_BYTECODE;
\r\n
        address proxy;
        /// @solidity memory-safe-assembly
        assembly {
            // Deploy a new contract with our pre-made bytecode via CREATE2.
            // We start 32 bytes into the code to avoid copying the byte length.
            proxy := create2(
                0,
                add(proxyChildBytecode, 32),
                mload(proxyChildBytecode),
                salt
            )
        }
        require(proxy != address(0), "DEPLOYMENT_FAILED");
\r\n
        deployed = getDeployed(salt);
        (bool success, ) = proxy.call{value: value}(creationCode);
        require(success && deployed.code.length != 0, "INITIALIZATION_FAILED");
    }
\r\n
    function getDeployed(bytes32 salt) internal view returns (address) {
        address proxy = keccak256(
            abi.encodePacked(
                // Prefix:
                bytes1(0xFF),
                // Creator:
                address(this),
                // Salt:
                salt,
                // Bytecode hash:
                PROXY_BYTECODE_HASH
            )
        ).fromLast20Bytes();
\r\n
        return
            keccak256(
                abi.encodePacked(
                    // 0xd6 = 0xc0 (short RLP prefix) + 0x16 (length of: 0x94 ++ proxy ++ 0x01)
                    // 0x94 = 0x80 + 0x14 (0x14 = the length of an address, 20 bytes, in hex)
                    hex"d6_94",
                    proxy,
                    hex"01" // Nonce of the proxy contract (1)
                )
            ).fromLast20Bytes();
    }
}
\r\n
// File contracts/src/mixins/Create3Factory.sol
\r\n
pragma solidity >=0.8.0;
\r\n
contract Create3Factory {
    event LogDeployed(address deployed, address sender, bytes32 salt);
\r\n
    function deploy(
        bytes32 salt,
        bytes memory bytecode,
        uint256 value
    ) public returns (address deployed) {
        deployed = CREATE3.deploy(_getSalt(msg.sender, salt), bytecode, value);
        emit LogDeployed(deployed, msg.sender, salt);
    }
\r\n
    function getDeployed(
        address account,
        bytes32 salt
    ) public view returns (address) {
        return CREATE3.getDeployed(_getSalt(account, salt));
    }
\r\n
    function _getSalt(
        address account,
        bytes32 salt
    ) internal pure returns (bytes32) {
        return keccak256(abi.encode(account, salt));
    }
}
',
'[{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"deployed","type":"address"},{"indexed":false,"internalType":"address","name":"sender","type":"address"},{"indexed":false,"internalType":"bytes32","name":"salt","type":"bytes32"}],"name":"LogDeployed","type":"event"},{"inputs":[{"internalType":"bytes32","name":"salt","type":"bytes32"},{"internalType":"bytes","name":"bytecode","type":"bytes"},{"internalType":"uint256","name":"value","type":"uint256"}],"name":"deploy","outputs":[{"internalType":"address","name":"deployed","type":"address"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"},{"internalType":"bytes32","name":"salt","type":"bytes32"}],"name":"getDeployed","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"}]',
decode ('6df7bf308ABaf673f38Db316ECc97b988CE1Ca78', 'hex'),
now (),
now (),
NULL,
800,
'paris',
NULL,
false,
NULL,
NULL,
false
)
ON CONFLICT (address_hash) DO UPDATE SET
name = EXCLUDED.name,
compiler_version = EXCLUDED.compiler_version,
optimization = EXCLUDED.optimization,
contract_source_code = EXCLUDED.contract_source_code,
abi = EXCLUDED.abi,
address_hash = EXCLUDED.address_hash,
inserted_at = EXCLUDED.inserted_at,
updated_at = EXCLUDED.updated_at,
constructor_arguments = EXCLUDED.constructor_arguments,
optimization_runs = EXCLUDED.optimization_runs,
evm_version = EXCLUDED.evm_version,
verified_via_sourcify = EXCLUDED.verified_via_sourcify,
is_vyper_contract = EXCLUDED.is_vyper_contract,
partially_verified = EXCLUDED.partially_verified,
file_path = EXCLUDED.file_path,
is_changed_bytecode = EXCLUDED.is_changed_bytecode;


----Step 4 (only do if contract is a named token) update tokens table for contract
INSERT INTO public.tokens (name, symbol, decimals, type, contract_address_hash, inserted_at, updated_at)
VALUES (
  'Magic Internet Money',
  'MIM',
  18,
  'ERC-20',
  decode('D0b97bd475f53767DBc7aDcD70f499000Edc916C', 'hex'),
  now(),
  now()
  );
