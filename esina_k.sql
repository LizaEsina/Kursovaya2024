-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Дек 11 2024 г., 08:49
-- Версия сервера: 10.11.10-MariaDB-ubu2204
-- Версия PHP: 8.2.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `esina_k`
--

-- --------------------------------------------------------

--
-- Структура таблицы `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `cart`
--

INSERT INTO `cart` (`id`, `user_id`, `created_at`) VALUES
(6, 4, '2024-12-01 19:31:00'),
(7, 8, '2024-12-03 08:05:16'),
(8, 10, '2024-12-03 08:06:22'),
(9, 13, '2024-12-09 06:36:23');

-- --------------------------------------------------------

--
-- Структура таблицы `cart_item`
--

CREATE TABLE `cart_item` (
  `id` int(11) NOT NULL,
  `cart_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_price` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `cart_item`
--

INSERT INTO `cart_item` (`id`, `cart_id`, `product_id`, `product_price`, `created_at`) VALUES
(8, 6, 2, 43500, '2024-12-01 20:11:18'),
(9, 6, 2, 43500, '2024-12-01 20:11:59'),
(10, 6, 1, 12300, '2024-12-01 20:22:29'),
(11, 6, 1, 12300, '2024-12-02 06:11:06'),
(12, 8, 1, 12300, '2024-12-03 08:06:50'),
(13, 8, 2, 43500, '2024-12-03 08:07:08'),
(14, 8, 2, 43500, '2024-12-04 08:15:37'),
(15, 8, 1, 12300, '2024-12-04 08:16:08'),
(16, 8, 1, 12300, '2024-12-04 08:17:29'),
(18, 9, 2, 43500, '2024-12-09 06:38:21'),
(21, 9, 1, 12300, '2024-12-09 06:45:34');

-- --------------------------------------------------------

--
-- Структура таблицы `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `category`
--

INSERT INTO `category` (`id`, `name`, `description`) VALUES
(1, 'Женские ароматы', 'Вся женская парфюмерия'),
(2, 'Мужские ароматы', 'Вся мужская парфюмерия'),
(3, 'Унисекс ароматы', 'Парфюмерия для мужчин и женщин'),
(4, 'Детские ароматы', 'Детская парфюмерия');

-- --------------------------------------------------------

--
-- Структура таблицы `order`
--

CREATE TABLE `order` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `status` enum('в стадии рассмотрения','отправлено','доставлено','отменено') NOT NULL DEFAULT 'в стадии рассмотрения',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `name` varchar(255) NOT NULL,
  `phone` varchar(40) NOT NULL,
  `address` varchar(255) NOT NULL,
  `payment_method` set('Банковская карта','Наличные') NOT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `cart_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `order`
--

INSERT INTO `order` (`id`, `user_id`, `status`, `created_at`, `name`, `phone`, `address`, `payment_method`, `comment`, `cart_id`) VALUES
(5, 4, 'в стадии рассмотрения', '2024-12-02 06:13:26', 'Есина Елизавета Дмитриевна', '+7 999 138 19 86', 'Санкт-Петербург Авиаконструкторов 28', 'Наличные', NULL, 6),
(6, 10, 'в стадии рассмотрения', '2024-12-04 08:20:21', 'Есина Лиза Дмитриевна', '+7 999 138 19 86', 'Спб пкгх', 'Наличные', NULL, 8),
(7, 13, 'в стадии рассмотрения', '2024-12-09 06:50:43', 'Иван Иванович Иванов', '+7 999 138 19 86', 'ул. Пушкина, д. 10, кв. 5', 'Банковская карта', 'Доставить к вечеру', 9);

-- --------------------------------------------------------

--
-- Структура таблицы `product`
--

CREATE TABLE `product` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `price` int(255) NOT NULL,
  `category_id` int(11) NOT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `fragrance_group` varchar(255) NOT NULL,
  `base_notes` varchar(255) NOT NULL,
  `volume` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `product`
--

INSERT INTO `product` (`id`, `name`, `description`, `price`, `category_id`, `photo`, `fragrance_group`, `base_notes`, `volume`) VALUES
(1, 'Dior Miss Dior', 'Miss Dior, появившийся на свет в 1947 году, — один из самых знаменитых ароматов Dior. Как и многие другие творения Дома, он был создан для того, чтобы сделать жизнь женщин лучше.', 12300, 1, '1.png', 'Цветочные', 'Мускус, ваниль, бобы тонка, сандал', '50 мл'),
(2, 'AMOUAGE Interlude 53', 'Обжигающий душу взрыв специй и смол в аромате Interlude 53 являет собой возвышенный момент гармонии в сердце хаоса.', 43500, 2, '2.jpg', 'древесные, пряные', '\r\nкожа, aгаровое дерево, пачули, сандал', '100'),
(3, 'ROOFA SPAIN Cool kids Chloe', 'Tуалетная вода roofa spain, созданная специально для детей, приучает их к уходу за собой, превращая его в игру. Ребенок сможет открывать для себя удивительный мир парфюмерии и пользоваться туалетной водой – прямо как мама!', 1500, 4, '4.jpg', 'цветочные', 'фиалка', '100'),
(4, 'Love', '123', 456, 1, '/home/esina/web/k-esina.xn--80ahdri7a.site/public_html/assets/uploads/cfb4eca5eeca16f936f81e40caafd3f972185121c56de7c36f6caf2fcab5eda3.png', 'болото', 'Болото', '100мл'),
(5, 'Montale Soleil de Capri Eau de Parfum', 'Бодрящий коктейль с итальянскими фруктами, солнечным грейпфрутом и экзотическим кумкватом, приправленный средиземноморскими специями.', 10625, 1, '/home/esina/web/k-esina.xn--80ahdri7a.site/public_html/assets/uploads/cfb4eca5eeca16f936f81e40caafd3f972185121c56de7c36f6caf2fcab5eda3.png', 'цветочные, фруктовые', 'ваниль, тоффи, амбра, мускус', '100');

-- --------------------------------------------------------

--
-- Структура таблицы `role`
--

CREATE TABLE `role` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `role`
--

INSERT INTO `role` (`id`, `name`) VALUES
(1, 'user'),
(2, 'admin');

-- --------------------------------------------------------

--
-- Структура таблицы `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `fio` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `role` int(11) NOT NULL DEFAULT 1,
  `phone` varchar(20) NOT NULL,
  `token` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `user`
--

INSERT INTO `user` (`id`, `fio`, `email`, `password`, `created_at`, `role`, `phone`, `token`) VALUES
(1, 'Есина Елизавета Дмитриевна', 'e5inaliz@yandex.ru', 'Qwerty123+', '2024-11-23 19:52:07', 1, '+79991381986', ''),
(2, 'admin', 'admin@mail.ru', 'Admin123+', '2024-11-23 19:52:43', 2, '+79999999999', ''),
(3, 'Канева Арина Сергеевна', 'test@mail.ru', '$2y$13$IKfrN8uSoT5R/wiAuOvA6OfFXyPEMQQdDBT1KHwKR11UBlft0shsC', '2024-11-23 20:30:28', 1, '+79999999992', '8T9TuyKAkkDblWW1IFM3I2kaLf2eyBSH'),
(4, 'Кравец Карина Владимировна', 'test@mail.ruq', '$2y$13$EU/SehPCjimGTufCR2fx9ekm1S1pPdffX4I53COmH6bgMabtHqeM.', '2024-11-25 15:55:59', 2, '89964295057', 'eXzS5WSTiCpu_D05ucY6HS58wg4FwO_A'),
(5, 'Иванов Иван иВАНОВИЧ', 'test1@mail.ruq', '$2y$13$hSZtBrtiSsq5eNb6iKdtTeemnbrozuP.RC3E6WOubY9ZR7RPjlFjC', '2024-11-27 06:54:00', 2, '89991381986', 'IGIbgZ-gXulf43gKgrTdApmvdOd0ZL8-'),
(6, 'Дудкин Виктор Степанович', 'dudkin@mail.ru', '$2y$13$YAycfd6gqnktyqx6uac07uZEJiCm1dx6k56zU7v1iUVuby6ie2XS2', '2024-12-01 21:28:33', 1, '+7 996 429 50 57', NULL),
(7, 'Дудкин Виктор Степанович', 'dudkin1@mail.ru', '$2y$13$E9NEt5WTnPBRBd3zSucLROmPtz8efe.74BWWnnc5Q2QFwoqhLcKDq', '2024-12-01 21:29:00', 1, '+7 996 429 50 57', NULL),
(8, 'Есина Елизавета Дмитриевна', 'e5inalizz@yandex.ru', '$2y$13$XWQQYL6qq05xgdUcbUfJzuWXsp3u6YO8gu4s7C0swXQ5kMKmpjdR6', '2024-12-02 06:23:12', 1, '+7 999 138 19 86', 'oadxy2e2dzMjRTgbXeVykpxVS0WLcEm-'),
(10, 'Есина Елизавета Дмитриевна', 'e5inalizz1@yandex.ru', '$2y$13$/WkcRL6/NT1PuD3JhTONBeRBTY4jHdO7wsepP9k8HAyfQGdwZoyQe', '2024-12-03 08:05:47', 1, '+7 999 138 19 86', 'oEsNB3IJY_gWRx3_-jVjto-N-APHigEL'),
(11, 'Есина Елизавета Дмитриевна', 'e5inalizz11@yandex.ru', '$2y$13$i0fQle294FjDigUSyGdYX.ac5m1x.YRQSPaFs2VhaPzpricQYU5aW', '2024-12-03 08:16:56', 1, '+7 999 138 19 86', 'cz5J8tl5vU9qAj59ZZadzFE59uT8xZ2o'),
(12, 'Есина Елизавета Дмитриевна', 'e5inalizz113@yandex.ru', '$2y$13$ZmlF3TLi3mJIvzrmhu523e/zJFe/eFbcBGz0LkuLSowSF3ghhMbNG', '2024-12-03 08:53:58', 1, '+7 999 138 19 86', NULL),
(13, 'Иван Иванович Иванов', 'user@user.ru', '$2y$13$XMHtCbvTAAsveJDudBzi0.Ogmb9BnCkEZotJ05KYT3o0FL2t0XDXO', '2024-12-09 06:14:43', 1, '+7 999 138 19 86', 'dKnSvpafrG7X7o9ENkhQ2jD7GjO98LdS');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id_2` (`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `cart_item`
--
ALTER TABLE `cart_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_id` (`cart_id`,`product_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Индексы таблицы `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `order`
--
ALTER TABLE `order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `cart_id` (`cart_id`);

--
-- Индексы таблицы `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`);

--
-- Индексы таблицы `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `role` (`role`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `cart_item`
--
ALTER TABLE `cart_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT для таблицы `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `order`
--
ALTER TABLE `order`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `product`
--
ALTER TABLE `product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `role`
--
ALTER TABLE `role`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Ограничения внешнего ключа таблицы `cart_item`
--
ALTER TABLE `cart_item`
  ADD CONSTRAINT `cart_item_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`),
  ADD CONSTRAINT `cart_item_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

--
-- Ограничения внешнего ключа таблицы `order`
--
ALTER TABLE `order`
  ADD CONSTRAINT `order_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `order_ibfk_2` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`);

--
-- Ограничения внешнего ключа таблицы `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`);

--
-- Ограничения внешнего ключа таблицы `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`role`) REFERENCES `role` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
