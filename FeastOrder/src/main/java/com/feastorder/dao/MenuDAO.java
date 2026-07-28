// Display all of the menus at one page using Hibernate to handle database operations to fetch the data
package com.feastorder.dao;

import com.feastorder.model.Category;
import com.feastorder.model.MenuItem;
import com.feastorder.util.HibernateUtil;

import org.hibernate.Session;
import org.hibernate.Transaction;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MenuDAO implements MenuRepository {

    // Returns every menu item, for the public menu page
    public List<MenuItem> getAllMenuItems() throws SQLException {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            List<MenuItem> items = session
                    .createQuery("from MenuItem order by name", MenuItem.class)
                    .list();
            attachCategoryNames(session, items);
            return items;
        }
    }

    // Returns menu items filtered by category, showing only "Desserts" or others categories
    public List<MenuItem> getMenuItemsByCategory(int categoryId) throws SQLException {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            List<MenuItem> items = session
                    .createQuery("from MenuItem where categoryId = :categoryId order by name", MenuItem.class)
                    .setParameter("categoryId", categoryId)
                    .list();
            attachCategoryNames(session, items);
            return items;
        }
    }

    // Returns a single menu item by id, to display a single dish's detail view (ingredients, nutrition, rating, price)
    public MenuItem getMenuItemById(int itemId) throws SQLException {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            MenuItem item = session.get(MenuItem.class, itemId);
            if (item != null) {
                attachCategoryNames(session, List.of(item));
            }
            return item;
        }
    }

    // Returns every category to display the list of categories used for menu filtering and the admin "Manage Categories" panel
    public List<Category> getAllCategories() throws SQLException {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Category order by categoryName", Category.class).list();
        }
    }

    // Inserts a new menu item (admin only)
    public boolean addMenuItem(MenuItem item) throws SQLException {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(item);
            tx.commit();
            return true;
        } catch (RuntimeException e) {
            if (tx != null) {
                tx.rollback();
            }
            throw e;
        }
    }

    // Updates an existing menu item (admin only)
    public boolean updateMenuItem(MenuItem item) throws SQLException {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(item);
            tx.commit();
            return true;
        } catch (RuntimeException e) {
            if (tx != null) {
                tx.rollback();
            }
            throw e;
        }
    }

    // Deletes a dish from the menu item by id
    public boolean deleteMenuItem(int itemId) throws SQLException {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            MenuItem item = session.get(MenuItem.class, itemId);
            if (item == null) {
                tx.rollback();
                return false;
            }
            session.remove(item);
            tx.commit();
            return true;
        } catch (RuntimeException e) {
            if (tx != null) {
                tx.rollback();
            }
            throw e;
        }
    }

    // let admin to inserts a new category (admin only)
    public boolean addCategory(Category category) throws SQLException {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(category);
            tx.commit();
            return true;
        } catch (RuntimeException e) {
            if (tx != null) {
                tx.rollback();
            }
            throw e;
        }
    }

    // let admin to deletes a category by id
    public boolean deleteCategory(int categoryId) throws SQLException {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Category category = session.get(Category.class, categoryId);
            if (category == null) {
                tx.rollback();
                return false;
            }
            session.remove(category);
            tx.commit();
            return true;
        } catch (RuntimeException e) {
            if (tx != null) {
                tx.rollback();
            }
            throw e;
        }
    }

    // Load every category once, then stamp the name onto each item. Ensures every dish shown on the menu displays its category name
    private void attachCategoryNames(Session session, List<MenuItem> items) {
        List<Category> categories = session.createQuery("from Category", Category.class).list();
        Map<Integer, String> namesById = new HashMap<>();
        for (Category c : categories) {
            namesById.put(c.getCategoryId(), c.getCategoryName());
        }
        for (MenuItem item : items) {
            item.setCategoryName(namesById.get(item.getCategoryId()));
        }
    }
}
