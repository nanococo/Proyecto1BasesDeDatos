package com.example.services.singletons;

import java.io.*;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class Common {

    public static String username;

    /**
     * @param url is the url
     * @return a string with the json response from the API
     */
    //~Kendall P
    public static String readJsonFromUrl(String url) {
        try (InputStream is = new URL(url).openStream()) {
            BufferedReader rd = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            return readAll(rd);
        } catch (IOException e) {
            return "Could not read the json from the url";
        }
    }

    /**
     * @param rd
     * @return a string
     * @throws IOException
     * Build strings and read all
     */
    //~Kendall P
    private static String readAll(Reader rd) throws IOException {
        StringBuilder sb = new StringBuilder();
        int cp;
        while ((cp = rd.read()) != -1) {
            sb.append((char) cp);
        }
        return sb.toString();
    }

}
