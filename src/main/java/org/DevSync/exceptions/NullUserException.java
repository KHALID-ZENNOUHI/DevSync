package org.DevSync.exceptions;

public class NullUserException extends RuntimeException {
    public NullUserException() {
        super("Invalid user");
    }
}
