//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./User.sol";

contract Ride {
    struct RideDetails {
        string pickupLocation;
        string dropLocation;
        string rideDate;
        string landmark;
        uint256 costToRide;
        address driver;
        bool complete;
        bool finalized;
        address[] rideRequests;
        address[] riders;
        uint256 completeAgreeCount;
        uint256 riderCountWhoFinalized;
    }

    address[] public riders;
    address public driver;
    string public pickupLocation;
    string public dropLocation;
    string public rideDate;
    string public landmark;
    uint256 public costToRide;
    bool public complete;
    bool public finalized;
    uint256 public completeAgreeCount;
    uint256 public riderCountWhoFinalized;
    address[] public rideRequests;

    mapping(address => bool) completeAgree;
    mapping(address => bool) acceptedRequests;
    mapping(address => bool) finalizedRiders;

    modifier restricted() {
        require(msg.sender == driver, "You are not allowed");
        _;
    }

    modifier isFinalized() {
        require(!finalizedRiders[msg.sender], "You have already finalized");
        _;
    }

    constructor(
        string memory _pickup,
        string memory _drop,
        string memory _landmark,
        string memory _date,
        uint256 _cost,
        address _driver
    ) {
        driver = _driver;
        pickupLocation = _pickup;
        dropLocation = _drop;
        rideDate = _date;
        landmark = _landmark;
        costToRide = _cost;
    }

    function sendRideRequest(address userContractAddress) public {
        User user = User(userContractAddress);
        user.addPreviousRide(address(this));
        rideRequests.push(msg.sender);
    }

    function acceptRideRequest(uint256 index) public restricted {
        address confirmedRider = rideRequests[index];
        riders.push(confirmedRider);
        removeAddressFromArray(rideRequests, confirmedRider);
        acceptedRequests[confirmedRider] = true;
    }

    function finalizeRide() public payable isFinalized {
        require(
            acceptedRequests[msg.sender],
            "Your request is not accepted by driver"
        );
        require(!finalized, "Ride is finalized");
        require(
            msg.value == costToRide,
            "Amount is less/greater than required"
        );

        riderCountWhoFinalized++;
        finalizedRiders[msg.sender] = true;
        if (riderCountWhoFinalized == riders.length) {
            finalized = true;
        }
    }

    function completeRide() public {
        require(
            acceptedRequests[msg.sender] || msg.sender == driver,
            "Your are not allowed!"
        );
        require(finalized, "Ride is not finalized yet!");
        require(!completeAgree[msg.sender], "You have already completed ride");

        completeAgreeCount++;
        completeAgree[msg.sender] = true;
        if (completeAgreeCount == riders.length + 1) {
            payable(driver).transfer(address(this).balance);
            complete = true;
        }
    }

    function cancleRideRequest(address userContractAddress) public {
        require(
            !acceptedRequests[msg.sender],
            "Your request is already accepted!"
        );

        User user = User(userContractAddress);
        user.removePreviousRide(address(this));

        removeAddressFromArray(rideRequests, msg.sender);
    }

    function cancleAcceptedRideRequest(address userContractAddress) public {
        require(acceptedRequests[msg.sender], "Your request is not accepted!");
        require(
            !finalizedRiders[msg.sender],
            "Cannot cancle request since its alredy finalized!"
        );

        User user = User(userContractAddress);
        user.removePreviousRide(address(this));

        removeAddressFromArray(riders, msg.sender);
        removeAddressFromArray(rideRequests, msg.sender);
        delete acceptedRequests[msg.sender];
    }

    function rejectAcceptedRideRequest(
        address riderAddress,
        address riderContractAddress
    ) public {
        require(msg.sender == driver);
        require(
            acceptedRequests[riderAddress],
            "Request not accepted for this rider"
        );
        require(
            !finalizedRiders[riderAddress],
            "The rider has finalized ride! cannot reject"
        );

        User user = User(riderContractAddress);
        user.removePreviousRide(address(this));

        removeAddressFromArray(riders, riderAddress);
        removeAddressFromArray(rideRequests, riderAddress);
        delete acceptedRequests[riderAddress];
    }

    function isFinalizedBy(address riderAddress) public view returns (bool) {
        return finalizedRiders[riderAddress];
    }

    function isCompletedBy(address riderAddress) public view returns (bool) {
        return completeAgree[riderAddress];
    }

    function isRequestAccepted() public view returns (bool) {
        return acceptedRequests[msg.sender];
    }

    function getDetails() public view returns (RideDetails memory) {
        RideDetails memory result = RideDetails({
            pickupLocation: pickupLocation,
            dropLocation: dropLocation,
            riders: riders,
            driver: driver,
            rideDate: rideDate,
            landmark: landmark,
            costToRide: costToRide,
            complete: complete,
            finalized: finalized,
            rideRequests: rideRequests,
            completeAgreeCount: completeAgreeCount,
            riderCountWhoFinalized: riderCountWhoFinalized
        });

        return result;
    }

    function removeAddressFromArray(
        address[] storage array,
        address addressToRemove
    ) internal returns (bool success) {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == addressToRemove) {
                array[i] = array[array.length - 1];
                array.pop();
                success = true;
                return success;
            }
        }
        success = false;
        return success;
    }
}
