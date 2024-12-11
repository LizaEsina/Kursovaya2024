<?php

namespace app\controllers;
use app\models\Order;
use app\models\OrderItem;
use app\models\Product;
use app\models\User;
use app\models\Cart;
use app\models\CartItem;
use Yii;

class OrderController extends RestController
{
    public $modelClass = 'app\models\Order';
    public function actions()
    {
        $actions = parent::actions();

        unset($actions['delete'], $actions['create'], $actions['update']);

        return $actions;
    }

    public function actionCreate() {
        $user = User::getByToken();
        if (!($user && $user->isAuthorized())) {
            return $this->Response(401, ['error' => ['message' => 'Вы не авторизованы']]);
        }
        $cart = Cart::find()->where(['user_id' => $user->id])->one();
        if (!$cart) {
            return $this->Response(400, ['error' => ['message' => 'Нет товаров в корзине']]);
        }
        
        $data = Yii::$app->request->post();
        $order = new Order();
        $order->load($data, '');
        $order->user_id = $user->id;
        $order->cart_id = $cart->id;
        if ($this->ValidationError($order)) return $this->ValidationError($order);
        $order->save();
        return $this->Response(200, ['message' => 'Заказ создан', 'order_id' => $order->id]);
    }

    public function actionGetCart() {
        $user = User::getByToken();
        if (!($user && $user->isAuthorized())) {
            return $this->Response(401, ['error' => ['message' => 'Вы не авторизованы']]);
        }
        $cart = Cart::find()->where(['user_id' => $user->id])->one();
        if (!$cart) {
            return $this->Response(400, ['error' => ['message' => 'Нет товаров в корзине']]);
        }
        $cart_items = CartItem::find()->where(['cart_id' => $cart->id]);
        if ($cart_items->count() == 0) {
            return $this->Response(400, ['error' => ['message' => 'Нет товаров в корзине']]);
        }
        $items = [];
        foreach ($cart_items->asArray()->all() as $item) {
            if (isset($items[$item['product_id']])) {
                $items[$item['product_id']]['quantity']++;
            }
            else {
                $items[$item['product_id']] = $item;
                $items[$item['product_id']]['quantity'] = 1;
            }
            $items[$item['product_id']]['total_price'] = $item['product_price'] * $items[$item['product_id']]['quantity'];
        }
        
        return $this->Response(200, ['data' => array_values($items)]);
    }

    public function actionAddToCart() {
        $user = User::getByToken();
        if (!($user && $user->isAuthorized())) {
            return $this->Response(401, ['error' => ['message' => 'Вы не авторизованы']]);
        }
        $cart = Cart::find()->where(['user_id' => $user->id])->one();
        if (!$cart) {
            $cart = new Cart();
            $cart->user_id = $user->id;
            $cart->save();
        }
        $product_id = Yii::$app->request->post('product_id');
        $cartItem = new CartItem();
        $cartItem->cart_id = $cart->id;
        $cartItem->product_price = Product::find()->where(['id' => $product_id])->one()->price;
        $cartItem->product_id = $product_id;
        $cartItem->save();
        return $this->Response(201, [
            'message' => 'Товар добавлен в корзину'
        ]);
    }

    public function actionRemoveOneFromCart($id) {
        $user = User::getByToken();
        if (!($user && $user->isAuthorized())) {
            return $this->Response(401, ['error' => ['message' => 'Вы не авторизованы']]);
        }
        $cart = Cart::find()->where(['user_id' => $user->id])->one();
        if (!$cart) {
            return $this->Response(400, ['error' => ['message' => 'Нет товаров в корзине']]);
        }
        $cart_item = CartItem::find()->where(['cart_id' => $cart->id, 'product_id' => $id])->one();
        if (!$cart_item) {
            return $this->Response(400, ['error' => ['message' => 'Товар не найден в корзине']]);
        }
        $cart_item->delete();
        return $this->Response(204);
    }

    public function actionRemoveAllFromCart($id) {
        $user = User::getByToken();
        if (!($user && $user->isAuthorized())) {
            return $this->Response(401, ['error' => ['message' => 'Вы не авторизованы']]);
        }
        $cart = Cart::find()->where(['user_id' => $user->id])->one();
        if (!$cart) {
            return $this->Response(400, ['error' => ['message' => 'Нет товаров в корзине']]);
        }
        if (!CartItem::find()->where(['cart_id' => $cart->id, 'product_id' => $id])) {
            return $this->Response(400, ['error' => ['message' => 'Товар не найден в корзине']]);
        }
        CartItem::deleteAll(['cart_id' => $cart->id, 'product_id' => $id]);
        return $this->Response(204);
    }

    public function actionUser() {
        $user = User::getByToken(); 
        if (!($user && $user->isAuthorized())) { 
            return $this->Response(401, ['error' => ['message' => 'Вы не авторизованы']]); 
        } 
        $query = Order::find()->where(['user_id' => $user->id]); 
        if ($query->count() == 0) { 
            return $this->Response(204); 
        } 
        $orders = $query->with(['cart', 'cart.cartItems'])->all(); 
        $groupedOrders = []; 
        $statuses = [
            'в стадии рассмотрения' => 'on_moderation', 
            'отправлено' => 'sent', 
            'доставлено' => 'completed', 
            'отменено' => 'cancelled'
        ]; 
        foreach ($statuses as $status) { 
            $groupedOrders[$status] = []; 
        } 
        foreach ($orders as $order) { 
            $items = []; 
            if ($order->cart && $order->cart->cartItems) {
                foreach ($order->cart->cartItems as $item) {
                    $items[] = $item;
                }
            }
            $groupedOrders[$statuses[$order->status]][] = [
                'info' => $order, 
                'items' => $items
            ]; 
        } 
        return $this->Response(200, ['data' => $groupedOrders]); 
    }


    
}