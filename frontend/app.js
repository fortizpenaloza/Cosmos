'use strict';

// Declare app level module which depends on views, and components
angular.module('app_angular',[]).controller('HomeCtrl', ['$scope','$http',function($scope,$http) {

    	// Simple GET request example:
		$http({
  			method: 'GET',
  			url: 'http://172.20.10.3:8010/dataChannel/1'
    }).then(function successCallback(response) {
	     $scope.dataChannel = response.data;
    }, function errorCallback(response) {
  	   console.log('error');
    });
}]);