package samepage;

import java.io.Console;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.Base64;
import java.util.Scanner;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public final class PasswordUtil {

    private static final int ITERATIONS = 200_000;
    private static final int SALT_BYTES = 16;
    private static final int KEY_BITS = 256;

    private static final SecureRandom random =
        new SecureRandom();

    private PasswordUtil() {}

    public static String hashPassword(char[] password)
            throws Exception {

        byte[] salt = new byte[SALT_BYTES];
        random.nextBytes(salt);

        byte[] hash = deriveKey(password, salt, ITERATIONS);

        Base64.Encoder encoder =
            Base64.getUrlEncoder().withoutPadding();

        return "pbkdf2$" + ITERATIONS + "$"
            + encoder.encodeToString(salt) + "$"
            + encoder.encodeToString(hash);
    }

    public static boolean verifyPassword(
            char[] password, String storedHash) {

        if (storedHash == null ||
                !storedHash.startsWith("pbkdf2$")) {
            return false;
        }

        try {
            String[] parts = storedHash.split("\\$", -1);

            if (parts.length != 4) {
                return false;
            }

            int iterations = Integer.parseInt(parts[1]);

            if (iterations < 100_000 ||
                    iterations > 1_000_000) {
                return false;
            }

            Base64.Decoder decoder =
                Base64.getUrlDecoder();

            byte[] salt = decoder.decode(parts[2]);
            byte[] expected = decoder.decode(parts[3]);

            if (salt.length != SALT_BYTES ||
                    expected.length != KEY_BITS / 8) {
                return false;
            }

            byte[] actual =
                deriveKey(password, salt, iterations);

            return MessageDigest.isEqual(expected, actual);

        } catch (Exception e) {
            return false;
        }
    }

    private static byte[] deriveKey(
            char[] password, byte[] salt, int iterations)
            throws Exception {

        PBEKeySpec spec = new PBEKeySpec(
            password, salt, iterations, KEY_BITS
        );

        try {
            return SecretKeyFactory
                .getInstance("PBKDF2WithHmacSHA256")
                .generateSecret(spec)
                .getEncoded();

        } finally {
            spec.clearPassword();
        }
    }

    // Run this once to generate a password
    // for the existing demo account derek01.
    public static void main(String[] args)
            throws Exception {

        Console console = System.console();
        char[] password;

        if (console != null) {
            password = console.readPassword(
                "Choose a demo password: "
            );
        } else {
            System.out.print(
                "Choose a demo password: "
            );

            Scanner scanner = new Scanner(
                System.in, StandardCharsets.UTF_8
            );

            password = scanner.nextLine().toCharArray();
        }

        if (password == null || password.length < 8) {
            System.out.println(
                "Password must be at least 8 characters."
            );
            return;
        }

        try {
            String hash = hashPassword(password);

            System.out.println(
                "\nRun this in MySQL Workbench:"
            );

            System.out.println(
                "UPDATE `user` SET password_hash = '" +
                hash +
                "' WHERE username = 'derek01';"
            );

        } finally {
            Arrays.fill(password, '\0');
        }
    }
}
