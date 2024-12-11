<?php

namespace app\controllers;
use app\models\Product;
use app\models\User;
use yii\web\UploadedFile;
use Yii;

class ProductController extends RestController
{
    public $modelClass = 'app\models\Product';
    public function actions()
    {
        $actions = parent::actions();

        unset($actions['delete'], $actions['create'], $actions['update']);

        return $actions;
    }

    public function actionCreate() {
        $user = User::getByToken();
        if (!($user && $user->isAuthorized() && $user->isAdmin())) {
            return $this->Response(403, ['error' => ['message' => 'Доступ запрещен']]);
        }
        $data = Yii::$app->request->post();
        $product = new Product();
        $product->scenario = Product::SCENARIO_CREATE;
        $product->load($data, '');
        
        if (isset($data['photo'])) {
            $product->photo = UploadedFile::getInstanceByName('photo');
            if ($this->ValidationError($product)) return $this->ValidationError($product);
            $path = Yii::$app->basePath. '/assets/uploads/' . hash('sha256', $product->photo->baseName) . '.' . $product->photo->extension;
            $product->photo->saveAs($path);
            $product->photo = $path;
        }
        else {
            if ($this->ValidationError($product)) return $this->ValidationError($product);
        }
        $product->save();
        return $this->Response(201, [
            'perfume_id' => $product->id,
            'message' => 'Товар добавлен'
        ]);
    }

    public function actionUpgrade($id) {
        $user = User::getByToken();
        if (!($user && $user->isAuthorized() && $user->isAdmin())) {
            return $this->Response(403, ['error' => ['message' => 'Доступ запрещен']]);
        }
        $data = Yii::$app->request->post();
        $product = Product::findOne($id);
        if (!$product) {
            return $this->Response(204);
        }
        $product->scenario = Product::SCENARIO_UPDATE;
        $product->load($data, '');
            $photo = UploadedFile::getInstanceByName('photo');
            if ($this->ValidationError($product)) return $this->ValidationError($product);
            if (!is_null($photo)){
                $product->photo = $photo;
                $path = Yii::$app->basePath. '/assets/uploads/' . hash('sha256', $product->photo->baseName) . '.' . $product->photo->extension;
                $product->photo->saveAs($path);
                $product->photo = $path;

            }
        $product->save();
        return $this->Response(200, ['data' => $product]);
    }

    public function actionAll()
    {
        if (Product::find()) {
            return $this->Response(200, ['data' => Product::find()->select(['id','name', 'volume', 'price', 'photo'])->all()]);
        }
        return $this->Response(204);
    }

    public function actionOne($id)
    {
        $item = Product::findOne($id);
        if ($item) {
            return $this->Response(200, ['data' => $item]);
        }
        return $this->Response(204);
    }
}