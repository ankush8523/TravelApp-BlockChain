//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./Ride.sol";
import "./User.sol";

contract RideShare {
    mapping(string => address[]) private ridesFrom;
    mapping(string => address[]) private ridesTo;
    mapping(string => address[]) private ridesOn;
    mapping(address => address) private users;
    address public manager;

    modifier restricted() {
        require(users[msg.sender] != address(0), "User does not exist");
        _;
    }

    constructor() {
        manager = msg.sender;
    }

    function createUser(
        string memory _firstName,
        string memory _lastName,
        string memory _email,
        string memory _firebaseToken
    ) public {
        address newUser = address(
            new User(_firstName, _lastName, _email, _firebaseToken)
        );
        users[msg.sender] = newUser;
    }

    function findUser(address _user) public view restricted returns (address) {
        return users[_user];
    }

    function createRide(
        string memory _pickup,
        string memory _drop,
        string memory _landmark,
        string memory _date,
        uint256 _cost,
        address userContractAddress
    ) public restricted {
        address newRide = address(
            new Ride(_pickup, _drop, _landmark, _date, _cost, msg.sender)
        );
        ridesFrom[_pickup].push(newRide);
        ridesTo[_drop].push(newRide);
        ridesOn[_date].push(newRide);

        User user = User(userContractAddress);
        user.addPreviousRide(newRide);
    }

    function getRidesFrom(
        string memory _source
    ) public view returns (address[] memory) {
        return ridesFrom[_source];
    }

    function getRidesTo(
        string memory _destination
    ) public view returns (address[] memory) {
        return ridesTo[_destination];
    }

    function getRidesOn(
        string memory _date
    ) public view returns (address[] memory) {
        return ridesOn[_date];
    }
}
