// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { TodoList } from "../src/TodoList.sol";

contract TodoListTest is Test {

    TodoList internal todoContract;
    string todo;
    uint256 index;
    uint256 pendingSeconds = 10;

    function setUp() public {
        todoContract = new TodoList(pendingSeconds);
        todo = "Homework";
        index = 0;
    }

    function testGetTodo() public {
        todoContract.addTodo(todo);

        // expected todo is equal to getTodo(0)
        string memory expectedTodo = todoContract.getTodo(index);
        assertTrue(keccak256(abi.encodePacked(todo)) == keccak256(abi.encodePacked(expectedTodo)));
    }

    function testAddTodo() public {
        // addTodo
        todoContract.addTodo(todo);

        // expected todo is equal to getTodo(0)
        string memory expectedTodo = todoContract.getTodo(index);
        assertTrue(keccak256(abi.encodePacked(todo)) == keccak256(abi.encodePacked(expectedTodo)));
    }
    
    function testDeleteTodo() public {
        todoContract.addTodo(todo);
        todoContract.deleteTodo(index);
        string memory expectedTodo = todoContract.getTodo(index);
        assertTrue(keccak256(abi.encodePacked(expectedTodo)) == keccak256(abi.encodePacked("")));
    }

    function testGetAllTodo() public {
        uint256 times = 3;

        for (uint256 i = 0; i < times; i++) {
            todoContract.addTodo(todo);
        }

        string[] memory expectedAllTodo = todoContract.getAllTodo();
        assertTrue(expectedAllTodo.length == times);

        for (uint256 i = 0; i < times; i++) {
            assertTrue(keccak256(abi.encodePacked(expectedAllTodo[i])) == keccak256(abi.encodePacked(todo)));
        }
        

    }

    function testMoveToPending() public {
        todoContract.addTodo(todo);
        todoContract.moveToPending(index);

        string memory expectedTodo = todoContract.getTodo(index);
        assertTrue(keccak256(abi.encodePacked(expectedTodo)) == keccak256(abi.encodePacked("")));
        assertTrue(keccak256(abi.encodePacked(todoContract.todoPending(index))) == keccak256(abi.encodePacked(todo)));
    }

    function testMoveFromPending() public {
        todoContract.addTodo(todo);
        todoContract.moveToPending(index);
        todoContract.moveFromPending(index);

        string memory expectedTodo = todoContract.getTodo(index);
        assertTrue(keccak256(abi.encodePacked(expectedTodo)) == keccak256(abi.encodePacked(todo)));
        assertTrue(keccak256(abi.encodePacked(todoContract.todoPending(index))) == keccak256(abi.encodePacked("")));
    }

}
