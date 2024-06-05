#!/bin/bash

# File containing the products
PRODUCTS_FILE="products.txt"

# File to store the cart items
CART_FILE="cart.txt"

# Function to display products
display_products() {
    echo "Available Products:"
    cat $PRODUCTS_FILE | nl
}

# Function to add product to cart
add_to_cart() {
    echo "Enter the product number to add to your cart:"
    read product_number

    product=$(sed "${product_number}q;d" $PRODUCTS_FILE)
    if [ -z "$product" ]; then
        echo "Invalid product number"
    else
        echo "$product" >> $CART_FILE
        echo "$product added to your cart"
    fi
}

# Function to view cart
view_cart() {
    echo "Your Cart:"
    if [ -f $CART_FILE ]; then
        cat $CART_FILE | nl
    else
        echo "Your cart is empty"
    fi
}

# Function to checkout
checkout() {
    echo "Checking out..."
    total=0
    if [ -f $CART_FILE ]; then
        while IFS= read -r line
        do
            price=$(echo $line | awk '{print $2}')
            total=$(echo "$total + $price" | bc)
        done < $CART_FILE

        echo "Total amount: $total"
        rm $CART_FILE
    else
        echo "Your cart is empty"
    fi
}

# Main menu
while true; do
    echo "--------------------"
    echo "1. View Products"
    echo "2. Add to Cart"
    echo "3. View Cart"
    echo "4. Checkout"
    echo "5. Exit"
    echo "--------------------"
    echo "Enter your choice:"
    read choice

    case $choice in
        1)
            display_products
            ;;
        2)
            add_to_cart
            ;;
        3)
            view_cart
            ;;
        4)
            checkout
            ;;
        5)
            echo "Thank you for visiting!"
            break
            ;;
        *)
            echo "Invalid choice, please try again"
            ;;
    esac
done

