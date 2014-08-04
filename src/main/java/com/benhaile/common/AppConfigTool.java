package com.benhaile.common;

import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.XMLConfiguration;
/**
 * Created by oschina on 2014/8/3.
 */
public class AppConfigTool {

    private String configPath ="AppConfig.xml";
    private XMLConfiguration config;

    public AppConfigTool(){

        try {
            config =  new XMLConfiguration(configPath);
        } catch (ConfigurationException e) {
            // TODO: handle exception
            e.printStackTrace();
        }
    }

    public String getConfig(String name){
        String value="";
        try {
            value=config.getString("appconfig."+name);
        } catch (Exception e) {
            // TODO: handle exception
        }

        return value;
    }
}