// Keeps passwords secure across the whole app, satisfies the user requirement for signup/login
package com.feastorder.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

// Salted SHA-256 password hashing. Never store or compare plain-text
public class PasswordUtil {

	// Length of the random salt added to every password before hashing
    private static final int SALT_LENGTH_BYTES = 16;
    private static final SecureRandom RANDOM = new SecureRandom();

    // Utility class, static methods
    private PasswordUtil() {
    }

    // Hashes a plain password with a fresh random salt
    public static String hash(String plainPassword) {
        byte[] salt = new byte[SALT_LENGTH_BYTES];
        RANDOM.nextBytes(salt);
        byte[] hash = digest(plainPassword, salt);
        return Base64.getEncoder().encodeToString(salt) + ":" + Base64.getEncoder().encodeToString(hash);
    }

    // Checks a plain password attempt against a stored salted hash.
    public static boolean matches(String plainPassword, String storedHash) {
        String[] parts = storedHash.split(":", 2);
        if (parts.length != 2) {
            return false;
        }
        byte[] salt = Base64.getDecoder().decode(parts[0]);
        byte[] expectedHash = Base64.getDecoder().decode(parts[1]);
        byte[] actualHash = digest(plainPassword, salt);
        return MessageDigest.isEqual(expectedHash, actualHash);
    }

    // Shared hashing logic used by both hash() and matches() so registration and login always compute the hash the exact same way
    private static byte[] digest(String plainPassword, byte[] salt) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            return md.digest(plainPassword.getBytes());
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 not available", e);
        }
    }
}
