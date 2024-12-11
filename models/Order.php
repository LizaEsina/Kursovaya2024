<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "order".
 *
 * @property int $id
 * @property int $user_id
 * @property string $status
 * @property string $created_at
 * @property string $name
 * @property string $phone
 * @property string $address
 * @property string $payment_method
 * @property string|null $comment
 * @property int $cart_id
 *
 * @property Cart $cart
 * @property OrderItem[] $orderItems
 * @property User $user
 */
class Order extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'order';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['user_id', 'name', 'phone', 'address', 'payment_method', 'cart_id'], 'required'],
            [['user_id', 'cart_id'], 'integer'],
            [['status', 'payment_method'], 'string'],
            [['created_at'], 'safe'],
            [['name', 'address', 'comment'], 'string', 'max' => 255],
            [['phone'], 'string', 'max' => 40],
            [['phone'], 'match', 'pattern' => '/^\+7\s\d{3}\s\d{3}\s\d{2}\s\d{2}$/'],
            [['name'], 'match', 'pattern' => '/[а-яА-Яё-]+\s[а-яА-Яё-]+\s[а-яА-Яё-]+/u'],
            [['user_id'], 'exist', 'skipOnError' => true, 'targetClass' => User::class, 'targetAttribute' => ['user_id' => 'id']],
            [['cart_id'], 'exist', 'skipOnError' => true, 'targetClass' => Cart::class, 'targetAttribute' => ['cart_id' => 'id']],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'user_id' => 'User ID',
            'status' => 'Статус',
            'created_at' => 'Дата создания',
            'name' => 'ФИО',
            'phone' => 'Номер телефона',
            'address' => 'Адрес',
            'payment_method' => 'Тип оплаты',
            'comment' => 'Комментарий',
            'cart_id' => 'Cart ID',
        ];
    }

    /**
     * Gets query for [[Cart]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getCart()
    {
        return $this->hasOne(Cart::class, ['id' => 'cart_id']);
    }

    /**
     * Gets query for [[OrderItems]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getOrderItems()
    {
        return $this->hasMany(OrderItem::class, ['order_id' => 'id']);
    }

    /**
     * Gets query for [[User]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getUser()
    {
        return $this->hasOne(User::class, ['id' => 'user_id']);
    }

    public function getCartItems()
    {
        return $this->hasMany(CartItem::class, ['id' => 'cart_id']);
    }
}
