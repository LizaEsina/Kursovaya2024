<?php

namespace app\models;

use Yii;

/**
 * This is the model class for table "product".
 *
 * @property int $id
 * @property string $name
 * @property string $description
 * @property int $price
 * @property int $category_id
 * @property string $photo
 * @property string $fragrance_group
 * @property string $base_notes
 * @property string $volume
 *
 * @property Category $category
 * @property OrderItem[] $orderItems
 */
class Product extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'product';
    }

    const SCENARIO_CREATE = 'create';
    const SCENARIO_UPDATE = 'update';

    public function scenarios()
    {
        $scenarios = parent::scenarios();
        $scenarios[self::SCENARIO_CREATE] = ['name', 'description', 'price', 'category_id', 'photo', 'fragrance_group', 'base_notes', 'volume'];
        $scenarios[self::SCENARIO_UPDATE] = ['name' ,'description', 'price', 'category_id', 'photo', 'fragrance_group', 'base_notes', 'volume'];
        return $scenarios;
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['name', 'description', 'price', 'category_id',  'fragrance_group', 'base_notes', 'volume'], 'required', 'on' => self::SCENARIO_CREATE],
            [['price', 'category_id'], 'integer'],
            [['name', 'description',
            //'photo', 
            'fragrance_group', 'base_notes', 'volume'], 'string', 'max' => 255],
            [['category_id'], 'exist', 'skipOnError' => true, 'targetClass' => Category::class, 'targetAttribute' => ['category_id' => 'id']],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'name' => 'Название',
            'description' => 'Описание',
            'price' => 'Цена',
            'category_id' => 'Категория',
            'photo' => 'Фотография',
            'fragrance_group' => 'Группа ароматов',
            'base_notes' => 'Базовые ноты',
            'volume' => 'Объем',
        ];
    }

    /**
     * Gets query for [[Category]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getCategory()
    {
        return $this->hasOne(Category::class, ['id' => 'category_id']);
    }

    /**
     * Gets query for [[OrderItems]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getOrderItems()
    {
        return $this->hasMany(OrderItem::class, ['product_id' => 'id']);
    }

    // public function beforeValidate(){
    //     $this->photo = UploadedFile::getInstanceByName('photo');
    //     return parent::beforeValidate();
    //     } 
       
}
