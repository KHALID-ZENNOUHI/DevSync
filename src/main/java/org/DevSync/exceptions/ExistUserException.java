package org.DevSync.exceptions;

public class ExistUserException extends RuntimeException {
    public ExistUserException(String email) {
        super("User with email " + email + " already exists");
    }
}
