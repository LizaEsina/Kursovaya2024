<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "user".
 *
 * @property int $id
 * @property string $fio
 * @property string $email
 * @property string $password
 * @property string $created_at
 * @property int $role
 *
 * @property Order[] $orders
 * @property Role $role0
 */
class User extends \yii\db\ActiveRecord
{

    const SCENARIO_LOGIN = 'login';
    const SCENARIO_REGISTER = 'register';

    public function scenarios()
    {
        $scenarios = parent::scenarios();
        $scenarios[self::SCENARIO_LOGIN] = ['email', 'password'];
        $scenarios[self::SCENARIO_REGISTER] = ['fio', 'email', 'password', 'phone'];
        return $scenarios;
    }

    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'user';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['fio', 'email', 'password', 'phone'], 'required', 'on' => self::SCENARIO_REGISTER],
            [['email', 'password'], 'required', 'on' => self::SCENARIO_LOGIN],
            [['created_at'], 'safe'],
            [['role'], 'integer'],
            [['phone'], 'string', 'max' => 20, 'min' => 11],
            [['password'], 'string', 'min' => 6],
            [['email'], 'unique', 'on' => self::SCENARIO_REGISTER],
            [['token'], 'string'],
            [['email'], 'email'],
        //    [['password'], 'match', 'pattern' => '/^(?=.*[A-Z])(?=.*[\d])(?=.*[a-z])(?=.*[\W])[a-zA-Z\d\W]{6,20}$/'],
           [['phone'], 'match', 'pattern' => '/^\+7\s\d{3}\s\d{3}\s\d{2}\s\d{2}$/'],
           [['fio'], 'match', 'pattern' => '/[а-яА-Яё-]+\s[а-яА-Яё-]+\s[а-яА-Яё-]+/u'],
            [['fio', 'email', 'password'], 'string', 'max' => 255],
            [['role'], 'exist', 'skipOnError' => true, 'targetClass' => Role::class, 'targetAttribute' => ['role' => 'id']],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'fio' => 'ФИО',
            'email' => 'Email',
            'password' => 'Пароль',
            'created_at' => 'Дата регистрации',
            'phone' => 'Телефон',
            'role' => 'Role',
        ];
    }

    /**
     * Gets query for [[Orders]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getOrders()
    {
        return $this->hasMany(Order::class, ['user_id' => 'id']);
    }

    /**
     * Gets query for [[Role0]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getRole0()
    {
        return $this->hasOne(Role::class, ['id' => 'role']);
    }

    public function fields()
    {
        $fields = parent::fields();

        // удаляем небезопасные поля
        unset($fields['password'], $fields['token']);

        $fields['ordersCount'] = function ($model) {
            return $model->getOrders()->count();
        };

        return $fields;
    }

    public function validatePassword($password) {
        return Yii::$app->security->validatePassword($password, $this->password);
    }

    public static function getByToken() {
        return self::findOne(['token' => str_replace('Bearer ', '', Yii::$app->request->headers->get('Authorization'))]);
    }

    public function isAdmin() {
        $roles = new Role;
        $admin_role = $roles::findOne(['name' => 'admin']);
        return $this->role === $admin_role['id'];
    }

    public function isAuthorized() {
        $token = str_replace('Bearer ', '', Yii::$app->request->headers->get('Authorization'));
        if (!$token || $token != $this->token) {
            return false;
        }
        return true;
    }
}
