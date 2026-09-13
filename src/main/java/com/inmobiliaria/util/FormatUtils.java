package com.inmobiliaria.util;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

/**
 * Utilidades generales para formateo de moneda colombiana, fechas y sanitización.
 */
public class FormatUtils {

    private static final Locale LOCALE_CO = new Locale("es", "CO");
    private static final NumberFormat CURRENCY_FORMAT = NumberFormat.getCurrencyInstance(LOCALE_CO);
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy hh:mm a");
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    static {
        CURRENCY_FORMAT.setMaximumFractionDigits(0);
    }

    public static String formatCurrency(BigDecimal amount) {
        if (amount == null) return "$0";
        return CURRENCY_FORMAT.format(amount);
    }

    public static String formatCurrency(double amount) {
        return CURRENCY_FORMAT.format(amount);
    }

    public static String formatDateTime(LocalDateTime dateTime) {
        if (dateTime == null) return "";
        return dateTime.format(DATE_TIME_FORMATTER);
    }

    public static String formatDate(LocalDateTime dateTime) {
        if (dateTime == null) return "";
        return dateTime.format(DATE_FORMATTER);
    }

    public static String sanitize(String input) {
        if (input == null) return "";
        return input.trim().replace("<", "&lt;").replace(">", "&gt;");
    }
}
