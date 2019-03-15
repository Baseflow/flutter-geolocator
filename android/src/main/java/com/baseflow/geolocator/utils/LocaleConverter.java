package com.baseflow.geolocator.utils;

import java.util.Locale;
import java.util.StringTokenizer;

public class LocaleConverter {
    private final static String LOCALE_DELIMITER = "_";

    public static Locale fromLanguageTag(String languageTag) {
        String language = null, country = null, variant = null;
        StringTokenizer tokenizer = new StringTokenizer(languageTag, LOCALE_DELIMITER, false);

        if(tokenizer.hasMoreTokens()) {
            language = tokenizer.nextToken();
        }

        if(tokenizer.hasMoreTokens()) {
            country = tokenizer.nextToken();
        }

        if(tokenizer.hasMoreTokens()) {
            variant = tokenizer.nextToken();
        }

        if(language != null && country != null && variant != null) {
            return new Locale(language, country, variant);
        } else if (language != null && country != null) {
            return new Locale(language, country);
        } else if (language != null) {
            return new Locale(language);
        }

        return null;
    }
}
