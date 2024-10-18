package org.DevSync.exceptions;

public class InvalidIdException extends RuntimeException {
    public InvalidIdException() {
        super("Invalid id");
    }
}
