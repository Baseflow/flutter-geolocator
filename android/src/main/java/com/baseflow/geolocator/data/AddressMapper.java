package com.baseflow.geolocator.data;

import android.location.Address;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AddressMapper {

  public static List<Map<String, Object>> toHashMapList(List<Address> addresses) {
    List<Map<String, Object>> hashMaps = new ArrayList<>(addresses.size());

    for (Address address : addresses) {
      Map<String, Object> hashMap = AddressMapper.toHashMap(address);
      hashMaps.add(hashMap);
    }

    return hashMaps;
  }

  private static Map<String, Object> toHashMap(Address address) {
    Map<String, Object> placemark = new HashMap<>();

    placemark.put("name", address.getFeatureName());
    placemark.put("isoCountryCode", address.getCountryCode());
    placemark.put("country", address.getCountryName());
    placemark.put("thoroughfare", address.getThoroughfare());
    placemark.put("subThoroughfare", address.getSubThoroughfare());
    placemark.put("postalCode", address.getPostalCode());
    placemark.put("administrativeArea", address.getAdminArea());
    placemark.put("subAdministrativeArea", address.getSubAdminArea());
    placemark.put("locality", address.getLocality());
    placemark.put("subLocality", address.getSubLocality());

    if (address.hasLatitude() && address.hasLongitude()) {
      Map<String, Double> positionMap = new HashMap<>();

      positionMap.put("latitude", address.getLatitude());
      positionMap.put("longitude", address.getLongitude());

      placemark.put("position", positionMap);
    }

    return placemark;
  }
}
