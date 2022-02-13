package com.baseflow.geolocator.location;

import java.util.Map;

public class AndroidIconResource {
    private final String name;
    private final String defType;

    public static AndroidIconResource parseArguments(Map<String, Object> arguments) {
        if (arguments == null) {
            return null;
        }

        final String name = (String) arguments.get("name");
        final String defType = (String) arguments.get("defType");

        return new AndroidIconResource(
                name,
                defType);
    }

    private AndroidIconResource(String name, String defType) {
        this.name = name;
        this.defType = defType;
    }

    public String getName() {
        return name;
    }

    public String getDefType() {
        return defType;
    }
}
