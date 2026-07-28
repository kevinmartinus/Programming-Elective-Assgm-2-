package com.feastorder.util;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

// Builds and holds a single shared Hibernate SessionFactory for the whole app, read from hibernate.cfg.xml on the classpath
public class HibernateUtil {

    private static final SessionFactory SESSION_FACTORY = buildSessionFactory();

    private static SessionFactory buildSessionFactory() {
        try {
            return new Configuration().configure().buildSessionFactory();
        } catch (Throwable e) {
            throw new ExceptionInInitializerError("Failed to build Hibernate SessionFactory: " + e);
        }
    }

    public static SessionFactory getSessionFactory() {
        return SESSION_FACTORY;
    }

    // Utility class, static access
    private HibernateUtil() {
    }
}
