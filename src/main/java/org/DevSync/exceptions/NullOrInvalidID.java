package org.DevSync.exceptions;

public class NullOrInvalidID extends RuntimeException {
    public NullOrInvalidID() {
        super("null or invalid id");
    }
}
