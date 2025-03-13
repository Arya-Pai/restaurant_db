package com.restaurantdb.model;

public class Category {
    private int categoryId;
    private String categoryName;
    private String type; 


    public Category(int categoryId, String categoryName, String type) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.type = type;
    }


    public int getCategoryId() {
        return categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public String getType() {
        return type;
    }


    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public void setType(String type) {
        this.type = type;
    }
}

