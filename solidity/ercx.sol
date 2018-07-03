pragma solidity ^0.4.23;

import "./ERCX20.sol";
import "./erc721/ERC721BasicToken.sol";

contract ERCX is ERC721BasicToken{
    mapping (address => Asset) assets; // Mapping of all assets mapped to ERC20 contract addr
    Asset[] public assetList; // List of all assets
    uint nonce = 0; // Nonce as id
    address[] tokens; // All tokens

    struct Asset { // All metadata we have for an asset at the moment
        string name;
        string symbol;
        address tokenAddr;
        address assetCreator;
        uint supply;
        uint id;
    }
    event AssetAdded( // Fire if an asset is created
        string name,
        uint supply,
        address tokenAddr
    );
    
    
    function createNewAsset(string _name, string _symbol, uint _supply) public { // Example arguments: "tOne", "test1", 1000
        address newAssetToken = new ERCX20(_symbol, _name, _supply, msg.sender); // Create new ERCX20 (just ERC20 but from the ERCX20 contract)
        assetList.push(Asset(_name, _symbol ,newAssetToken, msg.sender, _supply, nonce)); // Create asset and push it to a list of all assets
        assets[newAssetToken] = assetList[assetList.length - 1]; // Create the added asset also in the asset list mapping
        tokens.push(newAssetToken); // Push the created token address to the 
        _mint(msg.sender, nonce); // Mint new ERC721 token
        nonce++; // Add one to the nonce
        emit AssetAdded(_name, _supply, newAssetToken); // Emit the event signalling that the token has been added
    }
    
    function getTokenList() view public returns (address[] tokenList) {
        return tokens; // Get array of all tokens created
    }
    
    function getUserAssetBalance(address _tokenAddr) view public returns (uint amount, uint supply, string name, string symbol){
        uint _balance = ERC20(_tokenAddr).balanceOf(msg.sender) / (10 ** 18); // Get users balance of certain token
        return (_balance, assets[_tokenAddr].supply, assets[_tokenAddr].name, assets[_tokenAddr].symbol);
    }
    
    function getAssetData(address _tokenAddr) // Get metadata of certain asset
    view 
    public 
    returns (string name, string symbol ,address tokenAddr, address assetCreator, uint supply, uint id) {
        return (assets[_tokenAddr].name,assets[_tokenAddr].symbol ,assets[_tokenAddr].tokenAddr, assets[_tokenAddr].assetCreator, assets[_tokenAddr].supply, assets[_tokenAddr].id);
    }
}