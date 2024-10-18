package org.DevSync.exceptions;

public class EmptyUserException extends RuntimeException {
    public EmptyUserException() {
        super("User is empty");
    }
}
