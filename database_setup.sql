-- Таблиця правил
CREATE TABLE punctuation_rule (
    rule_id SERIAL PRIMARY KEY,
    rule_name VARCHAR(255) NOT NULL,
    explanation TEXT NOT NULL
);

-- Таблиця вправ
CREATE TABLE exercise (
    exercise_id SERIAL PRIMARY KEY,
    rule_id INTEGER REFERENCES punctuation_rule(rule_id) ON DELETE CASCADE,
    question TEXT NOT NULL
);

-- Таблиця для варіантів відповідей
CREATE TABLE exercise_option (
    option_id SERIAL PRIMARY KEY,
    exercise_id INTEGER REFERENCES exercise(exercise_id) ON DELETE CASCADE,
    option_text TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL DEFAULT false
);

INSERT INTO punctuation_rule (slug, rule_name, explanation) VALUES
-- Однорідні члени
('hom_no_conj', 'Однорідні члени (без сполучників)', 'Кома ставиться між однорідними членами речення, які не з’єднані сполучниками.'),
('hom_repeat_conj', 'Однорідні члени (повторювані сполучники)', 'Кома ставиться між однорідними членами, з’єднаними однаковими сполучниками (і...і, то...то).'),
('hom_protyp_conj', 'Однорідні члени (протиставні сполучники)', 'Кома ставиться між однорідними членами речення, з’єднаними протиставними сполучниками (а, але, однак, проте, зате тощо).'),
('hom_add_conj', 'Приєднувальні сполучники', 'Кома ставиться перед сполучниками, що приєднують додатковий елемент (і, а також, та й).'),
('hom_double_conj', 'Парні сполучники', 'Кома ставиться перед другим з парних сполучників (не тільки... а й, не стільки... скільки).'),
('hom_summary', 'Слова після узагальнюючих', 'Кома ставиться перед словосполуками, що стоять після узагальнюючих слів (а саме, як-от).'),
('word_repeat', 'Повторення слова', 'Кома ставиться при повторенні одного слова для підкреслення кількості або тривалості дії.'),

-- Виділення слів та звертань
('vocative', 'Звертання', 'Комами виділяються звертання та пов’язані з ними слова для вказання на особу, до якої звертаються.'),
('interjection', 'Вигуки', 'Кома ставиться після вигуків, якщо вони вимовляються з невеликою силою оклику.'),
('affirmative_words', 'Стверджувальні слова', 'Кома ставиться після стверджувальних слів (так, авжеж, добре), коли наступне речення розкриває їх конкретний зміст.'),
('parenthetical', 'Вставні слова та речення', 'Комами виділяються вставні слова (мабуть, отже, здається), що виражають ставлення мовця.'),

-- Звороти та відокремлені члени
('comparative', 'Порівняльний зворот', 'Комами виділяються порівняльні звороти, що вводяться словами як, мов, наче, ніби.'),
('concessive', 'Допустові речення', 'Кома ставиться перед сполучником хоч (хоча) у допустових реченнях.'),
('apposition_general', 'Прикладка', 'Комами виділяються прикладки, що пояснюють іменник або займенник, надаючи йому другу назву.'),
('apposition_markers', 'Прикладка з маркером', 'Комами виділяються прикладки, що починаються словами тобто, себто, або, як тощо.'),
('limiting_phrases', 'Обмежувальні звороти', 'Комами виділяються звороти, що починаються словами крім, особливо, замість, зокрема.'),
('adj_phrase', 'Відокремлене означення', 'Комами виділяються означення, виражені прикметниковими чи дієприкметниковими зворотами після іменника.'),
('clarifying_adv', 'Уточнювальна обставина', 'Комами виділяються уточнювальні обставини (місця, часу тощо), що конкретизують попередню дію.'),
('gerund_phrase', 'Дієприслівниковий зворот', 'Комами виділяються відокремлені обставини, виражені дієприслівниковими зворотами.'),
('single_gerund', 'Одиничний дієприслівник', 'Комою виділяються одиничні дієприслівники, що означають час, причину або умову дії.');

-- Складні речення
('complex_non_conj', 'Безсполучникове складне речення', 'Кома ставиться для відокремлення частин, що входять до безсполучникового складного речення.'),
('complex_coord', 'Складносурядне речення', 'Кома ставиться для відокремлення частин, що входять до складносурядного речення.'),
('complex_mixed', 'Складне речення з різними видами зв’язку', 'Кома ставиться для відокремлення частин у складних реченнях із безсполучниковим і сурядним зв’язком.'),
('complex_repeat_conj', 'Складне речення (повторювані сполучники)', 'Кома ставиться для відокремлення частин, що об’єднуються за допомогою повторюваних сполучників то...то, чи...чи, і...і.'),
('complex_subord', 'Складнопідрядне речення', 'Кома ставиться в складнопідрядному реченні для відокремлення підрядних речень від головного або від інших підрядних.');


-- ПРАВИЛО 1
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_no_conj'), 
 'Визначте місця, де потрібно поставити коми: Біль(1) давно затаєний у глибинах єства(2) раптом вирвався(3) вихлюпнувся(4) і розтікся кровоносними судинами(5) заповнив кожен капілярчик(6) кожну клітину тіла.', 
 '1', 'Н. Гуменюк', 
 'Коми 1 і 2 відокремлюють поширене означення. Коми 3 і 5 ставляться між однорідними присудками. Кома 6 ставиться між однорідними додатками.'),
-- Вправа 2
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_no_conj'), 
 'Визначте місця, де потрібно поставити коми: Скрекотіння(1) сюрчання(2) сичання(3) шурхіт(4) шелест(5) і шерех(6) дзижчання(7) здалека дзвін(8) шамрання(9) та шурхання...', 
 '1', 'М. Моклиця', 
 'Коми ставляться між однорідними членами речення, не з’єднаними сполучниками. Перед одиничними сполучниками і, та кома не ставиться.'),
-- Вправа 3
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_no_conj'), 
 'Визначте місця, де потрібно поставити коми: Спинаюсь дзвоником конвалій(1) і дзеленчу в зеленій тиші(2) твоїм прозорим відголоссям(3) кохана пісне(4) рідна пісне.', 
 '1', 'Й. Струцюк', 
 'Кома 3 відокремлює звертання. Кома 4 ставиться між однорідними звертаннями.'),
-- Вправа 4
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_no_conj'), 
 'Оберіть речення, у якому правильно розставлено коми між однорідними членами речення.', 
 '2', 'І. Корсак', 
 'Кома ставиться після відокремленого означення. Однорідні обставини поєднані сполучником і, тому кома між ними не потрібна.'),
-- Вправа 5
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_no_conj'), 
 'Оберіть речення, у якому правильно розставлено коми між однорідними частинами опису.', 
 '2', 'В. Гей', 
 'Коми розмежовують однорідні частини опису природи (граматичні основи): зацвів первоцвіт, в’ється пилок, береза зачудувалася.');
-- ДОДАВАННЯ ВАРІАНТІВ ВІДПОВІДЕЙ
-- Для Вправи 1
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Біль%затаєний%' LIMIT 1), '3, 4, 6', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Біль%затаєний%' LIMIT 1), '1, 2, 3, 4, 5, 6', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Біль%затаєний%' LIMIT 1), '1, 2, 3, 5, 6', true);
-- Для Вправи 2
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Скрекотіння%сюрчання%' LIMIT 1), '1, 2, 3, 4, 5, 6, 7, 8, 9', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Скрекотіння%сюрчання%' LIMIT 1), '1, 2, 3, 4, 6, 7, 8', true),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Скрекотіння%сюрчання%' LIMIT 1), '1, 2, 3, 6, 8, 9', false);
-- Для Вправи 3
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE ILIKE '%Спинаюсь%дзвоником%'), '1, 2, 3, 4', false),
((SELECT exercise_id FROM exercise WHERE ILIKE '%Спинаюсь%дзвоником%'), '2, 4', false),
((SELECT exercise_id FROM exercise WHERE ILIKE '%Спинаюсь%дзвоником%'), '3, 4', true);
-- Для Вправи 4
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE author_name = 'І. Корсак'), 'Незрушна тиша над головами велелюддя, досі порушувана хіба передзвоном, нараз змінилася гулом суцільним де подив, з тривогою змішалися дивовижно.', false),
((SELECT exercise_id FROM exercise WHERE author_name = 'І. Корсак'), 'Незрушна тиша над головами велелюддя, досі порушувана хіба передзвоном легеньким численних церковних хоругов, нараз змінилася гулом суцільним, де подив з тривогою змішалися дивовижно і невіддільно.', true),
((SELECT exercise_id FROM exercise WHERE author_name = 'І. Корсак'), 'Незрушна тиша над головами велелюддя досі порушувана хіба передзвоном легеньким численних церковних хоругов нараз змінилася гулом суцільним, де подив з тривогою змішалися дивовижно і невіддільно.', false);
-- Для Вправи 5
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE author_name = 'В. Гей'), 'Першим коханням зацвів первоцвіт в''ється пилок із ліщинових віт біла береза замріяним оком зачудувалася небом високим.', false),
((SELECT exercise_id FROM exercise WHERE author_name = 'В. Гей'), 'Першим коханням зацвів первоцвіт, в''ється пилок із ліщинових віт, біла береза замріяним оком зачудувалася небом високим.', true),
((SELECT exercise_id FROM exercise WHERE author_name = 'В. Гей'), 'Першим коханням зацвів первоцвіт, в''ється пилок із ліщинових віт біла береза замріяним оком зачудувалася небом високим.', false);

-- ПРАВИЛО 2
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_repeat_conj'), 
 'Визначте місця, де потрібно поставити коми: Нас вже ніщо не мучить(1) і не гнобить(2) ні рабство затхле(3) ні гримучі зради(4) ні порожнеча.', 
 '1', 'Й. Струцюк', 
 'Коми 3 і 4 розділяють однорідні підмети при повторюваному сполучнику ні... ні після узагальнювального слова ніщо.'),
-- Вправа 2
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_repeat_conj'), 
 'Визначте місця, де потрібно поставити коми: Вростають у вічність(1) і пісня(2) і казка(3) вогнем перевиті(4) і думи(5) досвітніми зорями вмиті.', 
 '1', 'В. Гей (мод. Бондарчуком)', 
 'При повторенні сполучника і... і... кома ставиться перед другим і наступними однорідними членами. Коми 3 і 5 відокремлюють означення.'),
-- Вправа 3
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_repeat_conj'), 
 'Визначте місця, де потрібно поставити коми: Антична пітьма затушовує(1) і образú(2) і όбрази(3) й обрáзи.', 
 '1', 'Н. Гуменюк (мод. Бондарчуком)', 
 'При повторюваних сполучниках і... і... й коми ставляться між однорідними членами, починаючи з другої позиції.'),
-- Вправа 4
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_repeat_conj'), 
 'Оберіть речення, у якому правильно розставлено коми при повторюваних сполучниках.', 
 '2', 'В. Простопчук', 
 'Коми розділяють частини складного речення та однорідні присудки при повторюваному сполучнику і... і.'),
-- Вправа 5
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_repeat_conj'), 
 'Знайдіть речення з правильним вживанням ком при однорідних додатках.', 
 '2', 'Н. Горик', 
 'Перша кома розділяє частини складного речення. Друга кома розділяє однорідні додатки при повторюваному сполучнику то... то.');
-- ДОДАВАННЯ ВАРІАНТІВ ВІДПОВІДЕЙ
-- Для Вправи 1
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question ILIKE '%ніщо%мучить%' LIMIT 1), '2, 3, 4', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%ніщо%мучить%' LIMIT 1), '1, 3, 4', true),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%ніщо%мучить%' LIMIT 1), '3, 4', false);
-- Для Вправи 2
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Вростають%вічність%' LIMIT 1), '1, 2, 3, 4', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Вростають%вічність%' LIMIT 1), '2, 4, 5', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Вростають%вічність%' LIMIT 1), '2, 3, 4, 5', true);
-- Для Вправи 3
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Антична%пітьма%' LIMIT 1), '1, 2, 3', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Антична%пітьма%' LIMIT 1), '1, 2', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Антична%пітьма%' LIMIT 1), '2, 3', true);
-- Для Вправи 4
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE author_name = 'В. Простопчук' AND format_type = '2' LIMIT 1), 'Люди пишуть листи, люди плачуть над ними, і сміються із них, і безжалісно рвуть.', true),
((SELECT exercise_id FROM exercise WHERE author_name = 'В. Простопчук' AND format_type = '2' LIMIT 1), 'Люди пишуть листи, люди плачуть над ними і сміються із них і безжалісно рвуть.', false),
((SELECT exercise_id FROM exercise WHERE author_name = 'В. Простопчук' AND format_type = '2' LIMIT 1), 'Люди пишуть листи люди плачуть над ними, і сміються із них, і безжалісно рвуть.', false);
-- Для Вправи 5
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE author_name = 'Н. Горик' AND format_type = '2' LIMIT 1), 'Мені і дереву співали птиці, і небо посилало звіддаля то хвилі голубі, то блискавиці.', true),
((SELECT exercise_id FROM exercise WHERE author_name = 'Н. Горик' AND format_type = '2' LIMIT 1), 'Мені і дереву співали птиці і небо посилало звіддаля то хвилі голубі то блискавиці.', false),
((SELECT exercise_id FROM exercise WHERE author_name = 'Н. Горик' AND format_type = '2' LIMIT 1), 'Мені, і дереву співали птиці, і небо посилало звіддаля, то хвилі голубі, то блискавиці.', false);

-- ПРАВИЛО 3
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_protyp_conj'), 
 'Визначте місця, де потрібно поставити коми: Сутність кольорів осягається поступово(1) протягом усього життя(2) але перші наближення до таємних глибин(3) відбуваються завдяки квітам.', 
 '1', 'М. Моклиця', 
 'Кома 2 ставиться перед протиставним сполучником "але", що розділяє частини складносурядного речення. Кома 1 потрібна для виділення уточнювальної обставини.'),
-- Вправа 2
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_protyp_conj'), 
 'Визначте місця, де потрібно поставити коми: Сонце нарешті розщедрилося на жменьку(1) не гарячих(2) зате яскравих променів.', 
 '1', 'Н. Гуменюк', 
 'Кома 2 ставиться між однорідними означеннями перед протиставним сполучником "зате".'),
-- Вправа 3
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_protyp_conj'), 
 'Визначте місця, де потрібно поставити коми: Змаліє все(1) під шаром часоплину(2) та в нетрях часу(3) не змаліє суть.', 
 '1', 'Н. Горик', 
 'Кома 2 ставиться перед сполучником "та", що вжитий у значенні "але" і розділяє частини складного речення.'),
-- Вправа 4
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_protyp_conj'), 
 'Оберіть варіант із правильною пунктуацією.', 
 '2', 'Н. Гуменюк', 
 'Коми виділяють відокремлене означення, всередині якого є однорідні члени (хижим, але ситим), з’єднані протиставним сполучником.'),
-- Вправа 5
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_protyp_conj'), 
 'Знайдіть речення з правильною пунктуацією перед сполучником "одначе".', 
 '2', 'В. Вербич (мод. Бондарчуком)', 
 'Одначе виступає протиставним сполучником (у значенні "але"), тому перед ним ставиться кома.');
-- 2. ДОДАВАННЯ ВАРІАНТІВ ВІДПОВІДЕЙ
-- Для Вправи 1 
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Сутність%кольорів%' LIMIT 1), '1, 2', true),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Сутність%кольорів%' LIMIT 1), '2', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Сутність%кольорів%' LIMIT 1), '2, 3', false);
-- Для Вправи 2 
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Сонце%розщедрилося%' LIMIT 1), '1, 2', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Сонце%розщедрилося%' LIMIT 1), '1', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Сонце%розщедрилося%' LIMIT 1), '2', true);
-- Для Вправи 3
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Змаліє%все%' LIMIT 1), '1, 2, 3', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Змаліє%все%' LIMIT 1), '2', true),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Змаліє%все%' LIMIT 1), '1, 2', false);
-- Для Вправи 4 
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Птах%' AND author_name = 'Н. Гуменюк' LIMIT 1), 'Птах, нагло заскочений хижим, але вже ситим звіром.', true),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Птах%' AND author_name = 'Н. Гуменюк' LIMIT 1), 'Птах, нагло заскочений хижим але вже ситим звіром.', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Птах%' AND author_name = 'Н. Гуменюк' LIMIT 1), 'Птах нагло заскочений хижим, але вже ситим звіром.', false);
-- Для Вправи 5
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Стіну%китайську%' LIMIT 1), 'Стіну китайську із космосу побачив одначе по людству ворон кряче.', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Стіну%китайську%' LIMIT 1), 'Стіну китайську із космосу побачив, одначе по людству ворон кряче.', true),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Стіну%китайську%' LIMIT 1), 'Стіну китайську із космосу побачив одначе, по людству ворон кряче.', false);

-- ПРАВИЛО 4
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_add_conj'), 
 'Визначте місця, де потрібно поставити коми: Справжня література — це насолода(1) й задоволення(2) а також невеличке мудре повчання(3) на повсякденний ужиток.', 
 '1', 'М. Моклиця', 
 'Кома 2 ставиться перед приєднувальним сполучником "а також", який вводить додатковий елемент речення.'),
-- Вправа 2
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_add_conj'), 
 'Визначте місця, де потрібно поставити коми: Кажуть(1) відважний був(2) і силу мав неабияку(3) а ще добре підвішеного язика.', 
 '1', 'І. Корсак', 
 'Кома 1 відокремлює вставне слово "кажуть". Кома 3 ставиться перед приєднувальним сполучником "а ще".'),
-- Вправа 3
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_add_conj'), 
 'Оберіть речення, у якому правильно вжито кому перед приєднувальним елементом.', 
 '2', 'І. Корсак', 
 'Кома ставиться перед приєднувальним сполучником "і навіть", що вносить додаткову інформацію до переліку міст.');
-- 2. ДОДАВАННЯ ВАРІАНТІВ ВІДПОВІДЕЙ
-- Варіанти для Вправи 1
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Справжня%література%' LIMIT 1), '1, 2', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Справжня%література%' LIMIT 1), '2', true),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Справжня%література%' LIMIT 1), '2, 3', false);
-- Варіанти для Вправи 2
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Кажуть%відважний%' LIMIT 1), '1, 3', true),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Кажуть%відважний%' LIMIT 1), '1, 2, 3', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Кажуть%відважний%' LIMIT 1), '1, 2', false);
-- Варіанти для Вправи 3
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Присилали%видання%' LIMIT 1), 'Присилали йому видання час від часу добрі знайомі з Києва й Львова, і навіть Буковини.', true),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Присилали%видання%' LIMIT 1), 'Присилали йому видання час від часу добрі знайомі з Києва й Львова і навіть Буковини.', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Присилали%видання%' LIMIT 1), 'Присилали йому видання час від часу добрі знайомі з Києва, й Львова, і навіть Буковини.', false);

-- ПРАВИЛО 5
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_double_conj'), 
 'Визначте місце коми в конструкції з протиставним сполучником: Людина гине не від води(1) а від власного страху(2) перед нею.', 
 '1', 'М. Моклиця', 
 'Кома ставиться перед протиставним сполучником "а", що з’єднує однорідні обставини, вжиті з часткою "не... а".'),
-- Вправа 2
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_double_conj'), 
 'Визначте місця, де потрібно поставити коми: ...нема в мене жодного морального права(1) не лише на святкову сукню(2) а й на безкоштовну цукерку.', 
 '1', 'М. Моклиця', 
 'Кома ставиться перед другою частиною парного сполучника "не лише... а й".'),
-- Вправа 3
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_double_conj'), 
 'Знайдіть речення з правильним вживанням розділових знаків при парному сполучнику.', 
 '2', 'В. Лис', 
 'Кома ставиться перед протиставним сполучником "але" у складі парного зв''язку.'),
-- Вправа 4
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_double_conj'), 
 'Знайдіть речення, де правильно вжито кому перед другою частиною сполучника «як... так і».', 
 '2', 'М. Моклиця (мод. Бондарчуком Д.)', 
 'При вживанні парного сполучника "як... так і" кома ставиться тільки перед другою його частиною.');
-- 2. ДОДАВАННЯ ВАРІАНТІВ ВІДПОВІДЕЙ
-- Варіанти для Вправи 1
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Людина%гине%не%від%води%' LIMIT 1), '2', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Людина%гине%не%від%води%' LIMIT 1), '1', true),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%Людина%гине%не%від%води%' LIMIT 1), '1, 2', false);
-- Варіанти для Вправи 2
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question ILIKE '%морального%права%не%лише%' LIMIT 1), '1, 2', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%морального%права%не%лише%' LIMIT 1), '2', true),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%морального%права%не%лише%' LIMIT 1), '1', false);
-- Варіанти для Вправи 3
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE author_name = 'В. Лис' AND format_type = '2' LIMIT 1), 'Хоч чарку-другу міг перехилити, але, в голові шуміло, не від випитого.', false),
((SELECT exercise_id FROM exercise WHERE author_name = 'В. Лис' AND format_type = '2' LIMIT 1), 'Хоч чарку-другу міг перехилити, але в голові шуміло, не від випитого.', false),
((SELECT exercise_id FROM exercise WHERE author_name = 'В. Лис' AND format_type = '2' LIMIT 1), 'Хоч чарку-другу міг перехилити, але в голові шуміло не від випитого.', true);
-- Варіанти для Вправи 4
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE author_name LIKE '%Бондарчуком%' AND format_type = '2' LIMIT 1), 'Процес пізнання це мандри як углиб власного нутра, так і в навколишній світ.', true),
((SELECT exercise_id FROM exercise WHERE author_name LIKE '%Бондарчуком%' AND format_type = '2' LIMIT 1), 'Процес пізнання це мандри, як углиб власного нутра так і в навколишній світ.', false),
((SELECT exercise_id FROM exercise WHERE author_name LIKE '%Бондарчуком%' AND format_type = '2' LIMIT 1), 'Процес пізнання це мандри як углиб власного нутра так і в навколишній світ.', false);

-- ПРАВИЛО 6
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_summary'), 
 'Визначте місце, де потрібно поставити кому перед пояснювальним словом. Ці спокуси мали різні назвиська(1) як-от(2) іграшки(3) панський одяг(4) небачені овочі-фрукти.', 
 '1', 'В. Лис (мод. Бондарчуком Д.)', 
 'Кома ставиться перед словом «як-от», яке стоїть після узагальнювального слова «назвиська» перед переліком однорідних додатків.'),
-- Вправа 2
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_summary'), 
 'Визначте місце розділового знака перед групою слів. Усе це сприятиме оптимізації діяльності(1) а саме(2) виконанню вправ(3) написанню творчих робіт.', 
 '1', 'На основі передмови', 
 'Кома 1 ставиться перед пояснювальним сполученням «а саме», а кома 3 розділяє однорідні члени речення.'),
-- Вправа 3
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_summary'), 
 'Оберіть речення, де правильно вжито кому перед пояснювальним словом.', 
 '2', 'Політика оцінювання', 
 'Після узагальнювального слова перед «як-от» ставиться кома, а після нього самого розділовий знак не потрібен, якщо далі йде перелік.'),
-- Вправа 4
((SELECT rule_id FROM punctuation_rule WHERE slug = 'hom_summary'), 
 'Оберіть речення з правильною пунктуацією при поясненні.', 
 '2', 'Термінологічний словник', 
 'Правило вимагає коми перед пояснювальним сполучником «а саме».');
-- 2. ДОДАВАННЯ ВАРІАНТІВ
-- Варіанти для Вправи 1
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question ILIKE '%спокуси%назвиська%' LIMIT 1), '1, 3, 4', true),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%спокуси%назвиська%' LIMIT 1), '2, 3, 4', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%спокуси%назвиська%' LIMIT 1), '1, 2, 3, 4', false);
-- Варіанти для Вправи 2
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question ILIKE '%оптимізації%діяльності%' LIMIT 1), '1', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%оптимізації%діяльності%' LIMIT 1), '2', false),
((SELECT exercise_id FROM exercise WHERE question ILIKE '%оптимізації%діяльності%' LIMIT 1), '1, 3', true);
-- Варіанти для Вправи 3
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE author_name = 'Політика оцінювання' AND format_type = '2' LIMIT 1), 'Форми контролю різноманітні як-от: проведення дискусій, виконання тестів, створення проєктів.', false),
((SELECT exercise_id FROM exercise WHERE author_name = 'Політика оцінювання' AND format_type = '2' LIMIT 1), 'Форми контролю різноманітні, як-от проведення дискусій, виконання тестів, створення проєктів.', true),
((SELECT exercise_id FROM exercise WHERE author_name = 'Політика оцінювання' AND format_type = '2' LIMIT 1), 'Форми контролю різноманітні як-от проведення дискусій, виконання тестів, створення проєктів.', false);
-- Варіанти для Вправи 4
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE author_name = 'Термінологічний словник' LIMIT 1), 'Вставні компоненти передають модальні значення, а саме: можливості, впевненості, вірогідності, сумніву.', false),
((SELECT exercise_id FROM exercise WHERE author_name = 'Термінологічний словник' LIMIT 1), 'Вставні компоненти передають модальні значення а саме, можливості, впевненості, вірогідності, сумніву.', false),
((SELECT exercise_id FROM exercise WHERE author_name = 'Термінологічний словник' LIMIT 1), 'Вставні компоненти передають модальні значення, а саме можливості, впевненості, вірогідності, сумніву.', true);

-- ПРАВИЛО 7
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
(7, 'Визначте місце, де потрібно поставити кому (або коми) між повторюваними словами. Іноді посеред білого дня зачинявся у своїй майстерні(1) обіймав мене(2) тулив до себе й гірко(3) гірко(4) плакав.', '1', 'Н. Гуменюк', 'Кома 3 ставиться між повторюваними прислівниками «гірко, гірко», що служать для підкреслення інтенсивності дії.'),
-- Вправа 2
(7, 'Визначте місце коми при повторенні однакових граматичних форм займенників. І хтось же має(1) хтось(2) же мусить, Боже мій, нести свій хрест(3) і на хресті вмирати.', '1', 'Н. Гуменюк', 'Кома 1 розділяє повторюваний займенник «хтось же» у ряду однорідних підметів для підсилення експресії.'),
-- Вправа 3
(7, 'Визначте місце ком. Погоди такої лихої(1) нили кості немилосердно в Пантелеймона Олександровича(2) тому він(3) відігріваючи їх(4) довго(5) довго сидів перед каміном.', '1', 'І. Корсак (мод. Бондарчуком Д.)', 'Кома 2 розділяє частини складного речення, 3 та 4 виділяють дієприслівниковий зворот, а 5 — повторювані прислівники.'),
-- Вправа 4
(7, 'Оберіть речення з правильною пунктуацією при повторенні слів.', '2', 'К. Корецька', 'На початку два короткі речення розділені крапкою для ритму, а в третьому комою відокремлено дієприслівниковий зворот.'),
-- Вправа 5
(7, 'Оберіть речення, де правильно вжито коми.', '2', 'Н. Гуменюк (мод. Бондарчуком Д.)', 'Коми розділяють повторювані означення, однорідні присудки та стоять перед «а». Перед «і знову» кома не потрібна.');
-- Варіанти для Вправи 1
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%майстерні(1)%' AND author_name = 'Н. Гуменюк' LIMIT 1), '1, 2', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%майстерні(1)%' AND author_name = 'Н. Гуменюк' LIMIT 1), '3, 4', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%майстерні(1)%' AND author_name = 'Н. Гуменюк' LIMIT 1), '3', true);
-- Варіанти для Вправи 2
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%хтось(2) же мусить%' AND author_name = 'Н. Гуменюк' LIMIT 1), '1', true),
((SELECT exercise_id FROM exercise WHERE question LIKE '%хтось(2) же мусить%' AND author_name = 'Н. Гуменюк' LIMIT 1), '1, 2, 3', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%хтось(2) же мусить%' AND author_name = 'Н. Гуменюк' LIMIT 1), '1, 2', false);
-- Варіанти для Вправи 3
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%Пантелеймона Олександровича%' AND author_name = 'І. Корсак (мод. Бондарчуком Д.)' LIMIT 1), '1, 2, 3, 4, 5', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Пантелеймона Олександровича%' AND author_name = 'І. Корсак (мод. Бондарчуком Д.)' LIMIT 1), '2, 3, 4, 5', true),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Пантелеймона Олександровича%' AND author_name = 'І. Корсак (мод. Бондарчуком Д.)' LIMIT 1), '2, 5', false);
-- Варіанти для Вправи 4
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією при повторенні слів.' AND author_name = 'К. Корецька' LIMIT 1), 'Минає мить. Минають миті літа. І ось вже соняшник погас у Лету літепло струсивши.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією при повторенні слів.' AND author_name = 'К. Корецька' LIMIT 1), 'Минає мить. Минають миті літа. І ось вже соняшник погас, у Лету літепло струсивши.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією при повторенні слів.' AND author_name = 'К. Корецька' LIMIT 1), 'Минає мить, минають миті літа, і ось вже соняшник погас у Лету літепло струсивши.', false);
-- Варіанти для Вправи 5
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно вжито коми.' AND author_name = 'Н. Гуменюк (мод. Бондарчуком Д.)' LIMIT 1), 'Воно слабкими, слабкими колами розійшлося над розколисаними вітром кущами і деревами впало на розбухлу дорогу на якусь мить стихло а тоді знову піднялося і знову опало.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно вжито коми.' AND author_name = 'Н. Гуменюк (мод. Бондарчуком Д.)' LIMIT 1), 'Воно слабкими, слабкими колами розійшлося над розколисаними вітром кущами і деревами, впало на розбухлу дорогу, на якусь мить стихло, а тоді знову піднялося і знову опало.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно вжито коми.' AND author_name = 'Н. Гуменюк (мод. Бондарчуком Д.)' LIMIT 1), 'Воно слабкими слабкими колами розійшлося над розколисаними вітром кущами і деревами, впало на розбухлу дорогу, на якусь мить стихло а тоді знову піднялося, і знову опало.', false);

-- ПРАВИЛО 8
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
(8, 
 'Оберіть варіант речення, у якому правильно розставлені розділові знаки.', 
 '2', 
 'К. Корецька', 
 'Після слова «тихше» ставиться кома, оскільки далі йде іменник «люди», що виконує функцію відокремленого звертання.');

INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, у якому правильно розставлені розділові знаки.' AND author_name = 'К. Корецька' LIMIT 1), 
 'Тихше, люди. Говоріть пошепки. Нехай ангели відпочинуть від щоденних турбот.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, у якому правильно розставлені розділові знаки.' AND author_name = 'К. Корецька' LIMIT 1), 
 'Тихше люди. Говоріть пошепки. Нехай ангели відпочинуть від щоденних турбот.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, у якому правильно розставлені розділові знаки.' AND author_name = 'К. Корецька' LIMIT 1), 
 'Тихше люди, говоріть пошепки. Нехай ангели відпочинуть від щоденних турбот.', false);

-- ПРАВИЛО 9
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
(9, 
 'Визначте розділовий знак після вигуку. Добридень(1) (с/С)вітлице-колиско! — до гаю березень мовить.', 
 '1', 'В. Гей', 
 'На місці 1 ставиться кома, оскільки вигук мовленнєвого етикету «Добридень» безпосередньо передує наступній частині речення.'),
-- Вправа 2
(9, 
 'Визначте місце коми в наступному реченні. Ага(1) он Нечуй-Левицький стиха на нього бурчить(2) бо остерігається відкоша.', 
 '1', 'І. Корсак', 
 'Кома 1 ставиться після вигуку «Ага», а кома 2 — перед підрядним сполучником «бо» в складнопідрядному реченні.'),
-- Вправа 3 
(9, 
 'Оберіть речення, де вигук відокремлено від тексту згідно з правилами пунктуації.', 
 '2', 'Н. Гуменюк', 
 'Вигук «Отакої!» виражає сильну реакцію і виділяється знаком оклику, а звертання «пані інопланетянко» — комою.'),
-- Вправа 4
(9, 
 'Оберіть варіант речення, де правильно вжито кому після вигуку.', 
 '2', 'І. Корсак (мод. Бондарчуком Д.)', 
 'Вигук «О» відокремлюється комою. Також комами виділяються звертання «Добродію» та вставна конструкція «спасибі Вам».');
-- Варіанти для Вправи 1 
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%Добридень(1)%' AND author_name = 'В. Гей' LIMIT 1), 'Кома (1)', true),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Добридень(1)%' AND author_name = 'В. Гей' LIMIT 1), 'Знак оклику (1)', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Добридень(1)%' AND author_name = 'В. Гей' LIMIT 1), 'Розділовий знак не потрібен', false);
Варіанти для Вправи 2
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%Ага(1)%' AND author_name = 'І. Корсак' LIMIT 1), '1', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Ага(1)%' AND author_name = 'І. Корсак' LIMIT 1), '2', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Ага(1)%' AND author_name = 'І. Корсак' LIMIT 1), '1, 2', true);
Варіанти для Вправи 3
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де вигук відокремлено від тексту згідно з правилами пунктуації.' AND author_name = 'Н. Гуменюк' LIMIT 1), 'Отакої! Що ж мені з вами робити пані інопланетянко?', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де вигук відокремлено від тексту згідно з правилами пунктуації.' AND author_name = 'Н. Гуменюк' LIMIT 1), 'Отакої, що ж мені з вами робити пані інопланетянко?', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де вигук відокремлено від тексту згідно з правилами пунктуації.' AND author_name = 'Н. Гуменюк' LIMIT 1), 'Отакої! Що ж мені з вами робити, пані інопланетянко?', true);
-- Варіанти для Вправи 4 
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, де правильно вжито кому після вигуку.' AND author_name = 'І. Корсак (мод. Бондарчуком Д.)' LIMIT 1), 'О, з великим уподобанням читав дорогою «Кайдашеву сім''ю», що Ви, Добродію, спасибі Вам, дали мені.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, де правильно вжито кому після вигуку.' AND author_name = 'І. Корсак (мод. Бондарчуком Д.)' LIMIT 1), 'О з великим уподобанням читав дорогою «Кайдашеву сім''ю», що Ви, Добродію, спасибі Вам, дали мені.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, де правильно вжито кому після вигуку.' AND author_name = 'І. Корсак (мод. Бондарчуком Д.)' LIMIT 1), 'О, з великим уподобанням читав дорогою «Кайдашеву сім''ю», що Ви, Добродію спасибі Вам, дали мені.', false);

-- ПРАВИЛО 10
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
(10, 
 'Визначте місце розділових знаків у реченні. Ні(1) ще наша Мати не вмирає(2)', 
 '1', 'П. Куліш (у переказі І. Корсака)', 
 'Після заперечувального слова «Ні» ставиться кома, а в кінці вислову — знак оклику, оскільки речення є окличним.'),
-- Вправа 2
(10, 
 'Визначте місце, де потрібно поставити кому. «Так(1) усе ніби таке(2) як було(3) і одночасно все змінилося», — думав Василь.', 
 '1', 'Ф. Одрач', 
 'Кома 1 відокремлює стверджувальне слово «Так», кома 2 виділяє порівняльний зворот, а кома 3 розділяє частини складного речення.'),
-- Вправа 3 
(10, 
 'Оберіть варіант речення, де правильно вжито кому.', 
 '2', 'В. Штинько', 
 'Слово «так» тут виступає підсилювальною часткою («дуже нелегко»), а не стверджувальним словом, тому кома не потрібна.'),
-- Вправа 4 
(10, 
 'Оберіть варіант речення, у якому усі коми правильно вжиті.', 
 '2', 'Ф. Одрач', 
 'Заперечне слово «Ні» відокремлюється комою. Між однорідними членами «стежки і доріжки» кома не ставиться.');
-- Варіанти для Вправи 1
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE 'Визначте місце розділових знаків у реченні. Ні(1)%' AND author_name LIKE '%Куліш%' LIMIT 1), '1 — кома, 2 — крапка', false),
((SELECT exercise_id FROM exercise WHERE question LIKE 'Визначте місце розділових знаків у реченні. Ні(1)%' AND author_name LIKE '%Куліш%' LIMIT 1), '1 — кома, 2 — знак оклику', true),
((SELECT exercise_id FROM exercise WHERE question LIKE 'Визначте місце розділових знаків у реченні. Ні(1)%' AND author_name LIKE '%Куліш%' LIMIT 1), '1 — знак оклику, 2 — знак оклику', false);
-- Варіанти для Вправи 2 
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%Так(1) усе ніби таке(2)%' AND author_name = 'Ф. Одрач' LIMIT 1), '1', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Так(1) усе ніби таке(2)%' AND author_name = 'Ф. Одрач' LIMIT 1), '1, 3', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Так(1) усе ніби таке(2)%' AND author_name = 'Ф. Одрач' LIMIT 1), '1, 2, 3', true);
-- Варіанти для Вправи 3
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, де правильно вжито кому.' AND author_name = 'В. Штинько' LIMIT 1), 'Так, нелегко змивати із душ рабський дух і облуду.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, де правильно вжито кому.' AND author_name = 'В. Штинько' LIMIT 1), 'Так нелегко змивати із душ рабський дух і облуду.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, де правильно вжито кому.' AND author_name = 'В. Штинько' LIMIT 1), 'Так нелегко змивати із душ рабський дух, і облуду.', false);
-- Варіанти для Вправи 4
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, у якому усі коми правильно вжиті.' AND author_name = 'Ф. Одрач' LIMIT 1), 'Ні, це вже не були стежки і доріжки його дитинства!', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, у якому усі коми правильно вжиті.' AND author_name = 'Ф. Одрач' LIMIT 1), 'Ні це вже не були стежки і доріжки його дитинства!', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, у якому усі коми правильно вжиті.' AND author_name = 'Ф. Одрач' LIMIT 1), 'Ні, це вже не були стежки, і доріжки його дитинства!', false);

-- ПРАВИЛО 11
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
(11, 
 'Визначте місце, де потрібно поставити кому для відокремлення вставного речення. Як казав мудрий Платон(1) мистецтво(2) це тінь на тлі вічності(3) від реального людського життя.', 
 '1', 'М. Моклиця', 
 'Конструкція «Як казав мудрий Платон» є вставним реченням, що вказує на джерело інформації, тому після нього на місці 1 обов''язково ставиться кома.'),
-- Вправа 2
(11, 
 'Визначте місце ком, якими виділяється вставне слово. По-перше(1) мені снились яскраві піднесені сни(2) по-друге(3) не могла намилуватися тамтешними краєвидами.', 
 '1', 'М. Моклиця', 
 'Слова «по-перше» та «по-друге» вказують на порядок викладу думок і є вставними. Кома 2 також розділяє частини безсполучникового речення.'),
-- Вправа 3
(11, 
 'Оберіть речення, де правильно оформлено вставне слово.', 
 '2', 'В. Вербич', 
 'Слово «кажуть» виступає в ролі вставного слова, яке вказує на джерело повідомлення, і на початку речення відокремлюється комою.'),
-- Вправа 4
(11, 
 'Оберіть речення з правильною пунктуацією при вставному слові.', 
 '2', 'В. Штинько', 
 'Слова «звісно» та «може» є вставними, вони виражають ступінь впевненості мовця і мають відокремлюватися комами.'),
-- Вправа 5
(11, 
 'Оберіть речення з правильною пунктуацією.', 
 '2', 'М. Моклиця', 
 'Між підметом і присудком перед словом «це» ставиться тире, а вставне слово «мабуть» з обох боків відокремлюється комами.');

-- Варіанти для Вправи 1
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%мудрий Платон(1)%' AND author_name = 'М. Моклиця' LIMIT 1), '1', true),
((SELECT exercise_id FROM exercise WHERE question LIKE '%мудрий Платон(1)%' AND author_name = 'М. Моклиця' LIMIT 1), '1, 2, 3', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%мудрий Платон(1)%' AND author_name = 'М. Моклиця' LIMIT 1), 'Розділові знаки не потрібні', false);

-- Варіанти для Вправи 2
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%По-перше(1)%по-друге(3)%' AND author_name = 'М. Моклиця' LIMIT 1), '1, 2', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%По-перше(1)%по-друге(3)%' AND author_name = 'М. Моклиця' LIMIT 1), '1, 3', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%По-перше(1)%по-друге(3)%' AND author_name = 'М. Моклиця' LIMIT 1), '1, 2, 3', true);

-- Варіанти для Вправи 3
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно оформлено вставне слово.' AND author_name = 'В. Вербич' LIMIT 1), 'Кажуть з неба вже три України посилають літа нам зозулями.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно оформлено вставне слово.' AND author_name = 'В. Вербич' LIMIT 1), 'Кажуть, з неба вже три України посилають літа нам зозулями.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно оформлено вставне слово.' AND author_name = 'В. Вербич' LIMIT 1), 'Кажуть з неба вже три України, посилають літа нам зозулями.', false);

-- Варіанти для Вправи 4
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією при вставному слові.' AND author_name = 'В. Штинько' LIMIT 1), 'Проплив перон. Він неживий. Він, звісно, не застогне. Може, ще поернеться назад?', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією при вставному слові.' AND author_name = 'В. Штинько' LIMIT 1), 'Проплив перон. Він неживий. Він звісно не застогне. Може, ще поернеться назад?', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією при вставному слові.' AND author_name = 'В. Штинько' LIMIT 1), 'Проплив перон. Він неживий. Він, звісно, не застогне. Може ще поернеться назад?', false);

-- Варіанти для Вправи 5
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією.' AND author_name = 'М. Моклиця' LIMIT 1), 'Екзотика — це, мабуть, пропорція звичного і незвичного.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією.' AND author_name = 'М. Моклиця' LIMIT 1), 'Екзотика це мабуть пропорція звичного і незвичного.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією.' AND author_name = 'М. Моклиця' LIMIT 1), 'Екзотика, це мабуть пропорція звичного і незвичного.', false);

-- ПРАВИЛО 12
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
(12, 
 'Визначте місце, де потрібно поставити кому перед порівняльним зворотом. Старе горіхове дерево з розкішною кроною хитається(1) мов(2) билина.', 
 '1', 'М. Моклиця', 
 'Кома 1 відокремлює порівняльний зворот «мов билина», який вказує на образний характер дії.'),
-- Вправа 2
(12, 
 'Визначте місце коми. Душа(1) ніби(2) затерпла(3) надійно відгородилася від світу звуконепроникною стіною...', 
 '1', 'Н. Гуменюк', 
 'Слово «ніби» тут виступає порівняльною часткою при присудку, а не вводить зворот. Кома 3 розділяє однорідні присудки.'),
-- Вправа 3
(12, 
 'Оберіть пунктуаційно коректний варіант речення.', 
 '2', 'В. Вербич', 
 'Порівняльний зворот «мов незбагненна святість» відокремлюється комою від підмета «світ».'),
-- Вправа 4
(12, 
 'Оберіть речення, де правильно розставлені коми.', 
 '2', 'Надія Гуменюк', 
 'Перша кома відокремлює порівняльний зворот «як отара», а друга — дієприкметниковий зворот, що стоїть після означуваного слова.'),
-- Вправа 5
(12, 
 'Оберіть речення з правильною пунктуацією.', 
 '2', 'Н. Гуменюк', 
 'Конструкція з «як» є підрядною порівняльною частиною складного речення, тому вона обов''язково відокремлюється комою.');

-- Варіанти для Вправи 1
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%хитається(1) мов(2)%' AND author_name = 'М. Моклиця' LIMIT 1), '1', true),
((SELECT exercise_id FROM exercise WHERE question LIKE '%хитається(1) мов(2)%' AND author_name = 'М. Моклиця' LIMIT 1), '2', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%хитається(1) мов(2)%' AND author_name = 'М. Моклиця' LIMIT 1), 'Розділовий знак не потрібен', false);

-- Варіанти для Вправи 2
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%Душа(1) ніби(2) затерпла(3)%' AND author_name = 'Н. Гуменюк' LIMIT 1), '1, 3', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Душа(1) ніби(2) затерпла(3)%' AND author_name = 'Н. Гуменюк' LIMIT 1), '1', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Душа(1) ніби(2) затерпла(3)%' AND author_name = 'Н. Гуменюк' LIMIT 1), '3', true);

-- Варіанти для Вправи 3
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть пунктуаційно коректний варіант речення.' AND author_name = 'В. Вербич' LIMIT 1), 'А світ, мов незбагненна святість.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть пунктуаційно коректний варіант речення.' AND author_name = 'В. Вербич' LIMIT 1), 'А світ мов незбагненна святість.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть пунктуаційно коректний варіант речення.' AND author_name = 'В. Вербич' LIMIT 1), 'А світ мов, незбагненна святість.', false);

-- Варіанти для Вправи 4
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно розставлені коми.' AND author_name = 'Надія Гуменюк' LIMIT 1), 'Над лісом стрімко зарухалися хмари і хутко посунули на захід, як отара, підхльоснута батогом невидимого небесного пастуха.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно розставлені коми.' AND author_name = 'Надія Гуменюк' LIMIT 1), 'Над лісом стрімко зарухалися хмари і хутко посунули на захід як отара підхльоснута батогом невидимого небесного пастуха.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно розставлені коми.' AND author_name = 'Надія Гуменюк' LIMIT 1), 'Над лісом стрімко зарухалися хмари і хутко посунули на захід, як отара підхльоснута батогом невидимого небесного пастуха.', false);

-- Варіанти для Вправи 5
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією.' AND author_name = 'Н. Гуменюк' LIMIT 1), 'Обійсть ставало все менше, село потроху згорталося, ховалося під зеленими заростями чагарників та бур''янів, як безлюдний острів ховається під штормовими хвилями океану.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією.' AND author_name = 'Н. Гуменюк' LIMIT 1), 'Обійсть ставало все менше село потроху згорталося ховалося під зеленими заростями чагарників та бур''янів як безлюдний острів ховається під штормовими хвилями океану.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією.' AND author_name = 'Н. Гуменюк' LIMIT 1), 'Обійсть ставало все менше, село потроху згорталося ховалося під зеленими заростями чагарників та бур''янів як безлюдний острів ховається під штормовими хвилями океану.', false);

-- ПРАВИЛО 13
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
(13, 
 'Визначте місце, де потрібно поставити кому. І все ж(1) незважаючи на повну безперспективність цієї справи(2) я ошивалась на сцені все своє шкільне життя...', 
 '1', 'М. Моклиця', 
 'Кома 1 відокремлює частку «і все ж», а кома 2 відокремлює поширений допустовий зворот, який починається з «незважаючи на».'),
-- Вправа 2
(13, 
 'Визначте місце, де потрібно поставити кому. ...николи не був пияком(1) як міг боронився од того зілля(2) хоч чарку-другу міг перехилити...', 
 '1', 'В. Лис', 
 'Кома 1 розділяє частини безсполучникового речення, а кома 2 ставиться перед допустовим сполучником «хоч».'),
-- Вправа 3
(13, 
 'Оберіть речення, де правильно оформлено допустовий зворот-порівняння або вставну конструкцію.', 
 '2', 'Надія Гуменюк', 
 'Допустова конструкція зі словом «хай» виділяється комами з обох боків, оскільки вона вносить додатковий відтінок значення.'),
-- Вправа 4
(13, 
 'Оберіть варіант речення, де правильно вжито розділові знаки.', 
 '2', 'В. Гей (мод. Бондарчуком Д.)', 
 'Перші дві частини розділяються комою як безсполучникові, а третя відокремлюється комою перед допустовим сполучником «хоча».');

-- Варіанти для Вправи 1
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE 'Визначте місце, де потрібно поставити кому. І все ж(1)%' AND author_name = 'М. Моклиця' LIMIT 1), '1', false),
((SELECT exercise_id FROM exercise WHERE question LIKE 'Визначте місце, де потрібно поставити кому. І все ж(1)%' AND author_name = 'М. Моклиця' LIMIT 1), '2', false),
((SELECT exercise_id FROM exercise WHERE question LIKE 'Визначте місце, де потрібно поставити кому. І все ж(1)%' AND author_name = 'М. Моклиця' LIMIT 1), '1, 2', true);

-- Варіанти для Вправи 2
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%николи не був пияком(1)%' AND author_name = 'В. Лис' LIMIT 1), '1', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%николи не був пияком(1)%' AND author_name = 'В. Лис' LIMIT 1), '2', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%николи не був пияком(1)%' AND author_name = 'В. Лис' LIMIT 1), '1, 2', true);

-- Варіанти для Вправи 3
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно оформлено допустовий зворот-порівняння або вставну конструкцію.' AND author_name = 'Надія Гуменюк' LIMIT 1), 'Вони вибирали інші скрипки, хай із гіршим звучанням, але звичайні й звичного кольору.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно оформлено допустовий зворот-порівняння або вставну конструкцію.' AND author_name = 'Надія Гуменюк' LIMIT 1), 'Вони вибирали інші скрипки хай із гіршим звучанням але звичайні й звичного кольору.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно оформлено допустовий зворот-порівняння або вставну конструкцію.' AND author_name = 'Надія Гуменюк' LIMIT 1), 'Вони вибирали інші скрипки, хай із гіршим звучанням але звичайні й звичного кольору.', false);

-- Варіанти для Вправи 4
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, де правильно вжито розділові знаки.' AND author_name = 'В. Гей (мод. Бондарчуком Д.)' LIMIT 1), 'Калина приморожена стоїть, летить віджиле листя понад гаєм, хоча в душі кохання біла віть цвіте травнево і не відцвітає...', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, де правильно вжито розділові знаки.' AND author_name = 'В. Гей (мод. Бондарчуком Д.)' LIMIT 1), 'Калина приморожена стоїть летить віджиле листя понад гаєм, хоча в душі кохання біла віть цвіте травнево і не відцвітає...', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, де правильно вжито розділові знаки.' AND author_name = 'В. Гей (мод. Бондарчуком Д.)' LIMIT 1), 'Калина приморожена стоїть, летить віджиле листя понад гаєм хоча в душі кохання біла віть цвіте травнево і не відцвітає...', false);

-- ПРАВИЛО 14
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
(14, 
 'Визначте, чи є в реченні відокремлена прикладка і де. В Раківській академії(1) Малопольщі(2) твоєму першому навчальному закладові(3) тобі дали першопочатки духовного світобачення...', 
 '1', 'І. Корсак', 
 'Коми 2 та 3 з обох боків виділяють відокремлену поширену прикладку «твоєму першому навчальному закладові», яка конкретизує власну назву.');

-- Варіанти для Вправи 1
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE 'Визначте, чи є в реченні відокремлена прикладка%' AND author_name = 'І. Корсак' LIMIT 1), '1, 2, 3', false),
((SELECT exercise_id FROM exercise WHERE question LIKE 'Визначте, чи є в реченні відокремлена прикладка%' AND author_name = 'І. Корсак' LIMIT 1), 'Розділові знаки не потрібні', false),
((SELECT exercise_id FROM exercise WHERE question LIKE 'Визначте, чи є в реченні відокремлена прикладка%' AND author_name = 'І. Корсак' LIMIT 1), '2, 3', true);

-- ПРАВИЛО 15
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
(15, 
 'Визначте місце, де потрібно поставити кому. Ці божевільні листопади(1) цебто(2) екстаз осінньої пори(3) тривали недовго.', 
 '1', 'Н. Гуменюк (мод. Бондарчуком Д.)', 
 'Прикладка приєднується пояснювальним маркером «цебто», тому її потрібно відокремити з обох боків комами 1 та 3.'),
-- Вправа 2
(15, 
 'Оберіть речення, де правильно оформлено марковану прикладку.', 
 '2', 'В. Лис (мод. Бондарчуком Д.)', 
 'Поширена прикладка починається маркером «себто» і стоїть після власного імені, тому потребує відокремлення комами з обох боків.'),
-- Вправа 3
(15, 
 'Оберіть речення з правильною пунктуацією при відокремленні прикладки.', 
 '2', 'В. Гей (мод. Бондарчуком Д.)', 
 'Сполучник «або» тут має пояснювальну функцію (тобто), тому прикладка «червоні вогники осені» відокремлюється з обох боків комами.');

-- Варіанти для Вправи 1
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%Ці божевільні листопади(1)%' AND author_name LIKE '%Гуменюк%' LIMIT 1), '2, 3', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Ці божевільні листопади(1)%' AND author_name LIKE '%Гуменюк%' LIMIT 1), '1', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Ці божевільні листопади(1)%' AND author_name LIKE '%Гуменюк%' LIMIT 1), '1, 3', true);

-- Варіанти для Вправа 2
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно оформлено марковану прикладку.' AND author_name LIKE '%В. Лис%' LIMIT 1), 'Іван Бройчик себто відомий на все село майстер постояв трохи надворі й рушив у вечірню мандрівку.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно оформлено марковану прикладку.' AND author_name LIKE '%В. Лис%' LIMIT 1), 'Іван Бройчик, себто відомий на все село майстер, постояв трохи надворі й рушив у вечірню мандрівку.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно оформлено марковану прикладку.' AND author_name LIKE '%В. Лис%' LIMIT 1), 'Іван Бройчик, себто відомий на все село майстер постояв трохи надворі й рушив у вечірню мандрівку.', false);

-- Варіанти для Вправа 3
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією при відокремленні прикладки.' AND author_name LIKE '%В. Гей%' LIMIT 1), 'На столі світяться святково горобині грона, або червоні вогники осені, нагадуючи про літо.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією при відокремленні прикладки.' AND author_name LIKE '%В. Гей%' LIMIT 1), 'На столі світяться святково горобині грона або червоні вогники осені нагадуючи про літо.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією при відокремленні прикладки.' AND author_name LIKE '%В. Гей%' LIMIT 1), 'На столі світяться святково горобині грона або, червоні вогники осені, нагадуючи про літо.', false);

-- ПРАВИЛО 16
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
(16, 
 'Визначте місце, де потрібно поставити коми. Відтоді й не думала Любка-однолюбка ні про кого(1) крім(2) нього.', 
 '1', 'Н. Гуменюк', 
 'Конструкція «крім нього» є обмежувальним зворотом. Оскільки зворот стоїть у кінці речення, кома 1 відокремлює його від основної частини.'),
-- Вправа 2
(16, 
 'Визначте місце коми. Праворуч(1) на самому його краєчку(2) самотньо(3) стояла хата, де він родився...', 
 '1', 'Ф. Одрач', 
 'Обставина «на самому його краєчку» конкретизує й уточнює прислівник місця «праворуч», тому виділяється комами 1 та 2 з обох боків.'),
-- Вправа 3
(16, 
 'Визначте, чи потрібна кома. Навіть(1) гриб(2) знає своє дерево.', 
 '1', 'Й. Струцюк', 
 'Слово «навіть» тут виступає в ролі підсилювальної частки на початку речення, а не відокремленого звороту, тому кома не потрібна.'),
-- Вправа 4
(16, 
 'Оберіть варіант речення, у якому правильно виділено відокремлену уточнювальну обставину місця.', 
 '2', 'Ф. Одрач', 
 'Конструкція «за вигоном» є уточнювальною обставиною місця до прислівника «лівіше», тому вона з обох боків виділена комами.'),
-- Вправа 5
(16, 
 'Оберіть речення з правильною пунктуацією при уточненні.', 
 '2', 'В. Вербич', 
 'Конструкція «на околиці Торчина» конкретизує вказівний прислівник «тут» і є відокремленою уточнювальною обставиною місця.'),
-- Вправа 6
(16, 
 'Оберіть варіант речення, у якому уточнення часового проміжку виділено без помилок.', 
 '2', 'В. Гей', 
 'Слово «опівночі» є звичайною обставиною часу і не потребує відокремлення. Кома ставиться лише перед сполучником «а».');

-- Варіанти для Вправи 1
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%Любка-однолюбка%ні про кого(1)%' AND author_name = 'Н. Гуменюк' LIMIT 1), '1', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Любка-однолюбка%ні про кого(1)%' AND author_name = 'Н. Гуменюк' LIMIT 1), '2', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Любка-однолюбка%ні про кого(1)%' AND author_name = 'Н. Гуменюк' LIMIT 1), '1, 2', true);

-- Варіанти для Вправи 2
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%Праворуч(1) на самому його краєчку(2)%' AND author_name = 'Ф. Одрач' LIMIT 1), '1, 3', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Праворуч(1) на самому його краєчку(2)%' AND author_name = 'Ф. Одрач' LIMIT 1), '2', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Праворуч(1) на самому його краєчку(2)%' AND author_name = 'Ф. Одрач' LIMIT 1), '1, 2', true);

-- Варіанти для Вправи 3
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%Навіть(1) гриб(2) знає%' AND author_name = 'Й. Струцюк' LIMIT 1), '1', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Навіть(1) гриб(2) знає%' AND author_name = 'Й. Струцюк' LIMIT 1), '2', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Навіть(1) гриб(2) знає%' AND author_name = 'Й. Струцюк' LIMIT 1), 'Розділовий знак не потрібен', true);

-- Варіанти для Вправи 4
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, у якому правильно виділено відокремлену уточнювальну обставину місця.' AND author_name = 'Ф. Одрач' LIMIT 1), 'Трохи лівіше за вигоном полискували бляхою куполи церковці, побіч якої п''явся вгору стрілистий осокір.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, у якому правильно виділено відокремлену уточнювальну обставину місця.' AND author_name = 'Ф. Одрач' LIMIT 1), 'Трохи лівіше, за вигоном, полискували бляхою куполи церковці, побіч якої п''явся вгору стрілистий осокір.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, у якому правильно виділено відокремлену уточнювальну обставину місця.' AND author_name = 'Ф. Одрач' LIMIT 1), 'Трохи лівіше за вигоном, полискували бляхою куполи церковці, побіч якої п''явся вгору стрілистий осокір.', false);

-- Варіанти для Вправи 5
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією при уточненні.' AND author_name = 'В. Вербич' LIMIT 1), 'Тут, на околиці Торчина сузір''я маргариток у траві оповідає небу про душі убієнних і спочилих у спокої.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією при уточненні.' AND author_name = 'В. Вербич' LIMIT 1), 'Тут на околиці Торчина, сузір''я маргариток у траві оповідає небу про душі убієнних і спочилих у спокої.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією при уточненні.' AND author_name = 'В. Вербич' LIMIT 1), 'Тут, на околиці Торчина, сузір''я маргариток у траві оповідає небу про душі убієнних і спочилих у спокої.', true);

-- Варіанти для Вправи 6
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, у якому уточнення часового проміжку виділено без помилок.' AND author_name = 'В. Гей' LIMIT 1), 'Опівночі, вітер стулив повіки на хвильку, а білий чаклун мороз скував обручами озеро.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, у якому уточнення часового проміжку виділено без помилок.' AND author_name = 'В. Гей' LIMIT 1), 'Опівночі вітер стулив повіки на хвильку, а білий чаклун мороз скував обручами озеро.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, у якому уточнення часового проміжку виділено без помилок.' AND author_name = 'В. Гей' LIMIT 1), 'Опівночі, вітер стулив повіки на хвильку а білий чаклун мороз скував обручами озеро.', false);

-- ПРАВИЛО 17
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
(17, 
 'Оберіть пунктуаційно правильний варіант речення.', 
 '2', 'В. Гей', 
 'Кома виділяє відокремлене означення (дієприкметниковий зворот) «Вчарований колоссям мирним дзвоном», що стоїть на початку речення перед означуваним словом «метал».');

-- Варіанти для Вправи 1
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть пунктуаційно правильний варіант речення.' AND author_name = 'В. Гей' LIMIT 1), 'Вчарований колоссям, мирним дзвоном, мовчить вогнем начинений метал.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть пунктуаційно правильний варіант речення.' AND author_name = 'В. Гей' LIMIT 1), 'Вчарований колоссям мирним дзвоном, мовчить вогнем начинений метал.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть пунктуаційно правильний варіант речення.' AND author_name = 'В. Гей' LIMIT 1), 'Вчарований колоссям мирним дзвоном мовчить вогнем начинений метал.', false);

-- ПРАВИЛО 19
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
(19, 
 'Визначте місце, де потрібно поставити коми. Юнак розгорнув ноти. Пружно повів на одному подиху головну тему(1) вслухаючись(2) у поодинокі(3) але потужні звуки.', 
 '1', 'А. Криштальський', 
 'Кома 1 відокремлює дієприслівниковий зворот, а на місці 3 вона розділяє однорідні означення перед протиставним сполучником «але».'),
-- Вправа 2
(19, 
 'Визначте місце коми, яка відокремлює дієприслівниковий зворот. Зустрівши вечір(1) вже дякую Богові(2) за ніч відвічну.', 
 '1', 'В. Вербич', 
 'Кома 1 відокремлює дієприслівниковий зворот «Зустрівши вечір», який стоїть на початку речення.'),
-- Вправа 3
(19, 
 'Визначте місце, де потрібно поставити коми. Коло кожного поля спиняв коня(1) стрибав на землю(2) й(3) перехрестившись(4) ставав на коліна.', 
 '1', 'В. Лис', 
 'Коми 3 та 4 з обох боків виділяють одиничний дієприслівник, що розриває зв’язок між сполучником і присудком. Кома 1 розділяє однорідні присудки.'),
-- Вправа 4
(19, 
 'Визначте місце ком. Василь(1) розглядаючись по кущах(2) пригадуючи собі ту чи ту галявину(3) відшукував її...', 
 '1', 'Федір Одрач', 
 'Коми 1 та 3 виділяють два однорідні дієприслівникові звороти. На місці 2 також ставиться кома, бо вони з’єднані безсполучниково.'),
-- Вправа 5
(19, 
 'Оберіть речення з правильною пунктуацією.', 
 '2', 'В. Вербич', 
 'Два однорідні дієприслівникові звороти поєднані єднальним сполучником «і», тому між ними кома не ставиться.'),
-- Вправа 6
(19, 
 'Оберіть варіант речення, у якому дієприслівниковий зворот відокремлено без помилок.', 
 '2', 'В. Штинько', 
 'Дієприслівниковий зворот «протерши вікнам заспані шибки» відокремлений комою від головної частини речення.'),
-- Вправа 7
(19, 
 'Оберіть речення, де правильно розставлена пунктуація.', 
 '2', 'М. Моклиця', 
 'Дієприслівниковий зворот відокремлений з обох боків. Сполучник «як» у значенні «у ролі» всередині звороту коми не потребує.'),
-- Вправа 8
(19, 
 'Оберіть речення без пунктуаційних помилок.', 
 '2', 'В. Лис', 
 'Дієприслівниковий зворот завершується комою перед головною частиною. Всередині звороту кома розділяє однорідні додатки.');

-- Варіанти для Вправи 1
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%головну тему(1) вслухаючись(2)%' AND author_name = 'А. Криштальський' LIMIT 1), '1', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%головну тему(1) вслухаючись(2)%' AND author_name = 'А. Криштальський' LIMIT 1), '2, 3', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%головну тему(1) вслухаючись(2)%' AND author_name = 'А. Криштальський' LIMIT 1), '1, 3', true);

-- Варіанти для Вправи 2
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%Зустрівши вечір(1)%' AND author_name = 'В. Вербич' LIMIT 1), '1', true),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Зустрівши вечір(1)%' AND author_name = 'В. Вербич' LIMIT 1), '2', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Зустрівши вечір(1)%' AND author_name = 'В. Вербич' LIMIT 1), '1, 2', false);

-- Варіанти для Вправи 3
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%спиняв коня(1) стрибав на землю(2)%' AND author_name = 'В. Лис' LIMIT 1), '1, 2', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%спиняв коня(1) стрибав на землю(2)%' AND author_name = 'В. Лис' LIMIT 1), '1, 3, 4', true),
((SELECT exercise_id FROM exercise WHERE question LIKE '%спиняв коня(1) стрибав на землю(2)%' AND author_name = 'В. Лис' LIMIT 1), '3, 4', false);

-- Варіанти для Вправи 4
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%Василь(1) розглядаючись по кущах(2)%' AND author_name = 'Федір Одрач' LIMIT 1), '1, 2', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Василь(1) розглядаючись по кущах(2)%' AND author_name = 'Федір Одрач' LIMIT 1), '2, 3', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Василь(1) розглядаючись по кущах(2)%' AND author_name = 'Федір Одрач' LIMIT 1), '1, 2, 3', true);

-- Варіанти для Вправи 5
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією.' AND author_name = 'В. Вербич' LIMIT 1), 'Послухай себе, ударивши в бубон і заплющивши очі.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією.' AND author_name = 'В. Вербич' LIMIT 1), 'Послухай себе, ударивши в бубон, і, заплющивши очі.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення з правильною пунктуацією.' AND author_name = 'В. Вербич' LIMIT 1), 'Послухай себе, ударивши в бубон, і заплющивши очі.', false);

-- Варіанти для Вправи 6
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, у якому дієприслівниковий зворот відокремлено без помилок.' AND author_name = 'В. Штинько' LIMIT 1), 'Всміхаюсь винувато, протерши вікнам заспані шибки.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, у якому дієприслівниковий зворот відокремлено без помилок.' AND author_name = 'В. Штинько' LIMIT 1), 'Всміхаюсь, винувато протерши вікнам заспані шибки.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення, у якому дієприслівниковий зворот відокремлено без помилок.' AND author_name = 'В. Штинько' LIMIT 1), 'Всміхаюсь винувато протерши, вікнам заспані шибки.', false);

-- Варіанти для Вправи 7
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно розставлена пунктуація.' AND author_name = 'М. Моклиця' LIMIT 1), 'Я ще трохи постояла і знов, відчуваючи мішок як смертельний тягар, попленталась додому.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно розставлена пунктуація.' AND author_name = 'М. Моклиця' LIMIT 1), 'Я ще трохи постояла і, знов відчуваючи мішок як смертельний тягар, попленталась додому.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно розставлена пунктуація.' AND author_name = 'М. Моклиця' LIMIT 1), 'Я ще трохи постояла і знов, відчуваючи мішок, як смертельний тягар, попленталась додому.', false);

-- Варіанти для Вправи 8
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення без пунктуаційних помилок.' AND author_name = 'В. Лис' LIMIT 1), 'Не тямлячись од хвилювання, од передчуття чогось невимовно щасливого, він підвівся з ліжка.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення без пунктуаційних помилок.' AND author_name = 'В. Лис' LIMIT 1), 'Не тямлячись од хвилювання од передчуття чогось невимовно щасливого він підвівся з ліжка.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення без пунктуаційних помилок.' AND author_name = 'В. Лис' LIMIT 1), 'Не тямлячись од хвилювання, од передчуття чогось невимовно щасливого він підвівся з ліжка.', false);

-- ПРАВИЛО 21
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
(21, 
 'Визначте місце, де потрібно поставити кому. По барабанних перетинках б''ють барабани світу(1) тривожно гуде(2) новинами діапазонний тамтам.', 
 '1', 'В. Простопчук', 
 'На місці 1 ставиться кома між двома частинами складного безсполучникового речення, що виражають одночасність подій.');

-- Варіанти для Вправи 1
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%По барабанних перетинках%' AND author_name = 'В. Простопчук' LIMIT 1), '1', true),
((SELECT exercise_id FROM exercise WHERE question LIKE '%По барабанних перетинках%' AND author_name = 'В. Простопчук' LIMIT 1), '2', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%По барабанних перетинках%' AND author_name = 'В. Простопчук' LIMIT 1), '1, 2', false);


-- ПРАВИЛО 22
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
(22, 
 'Визначте місце коми у складному реченні. Качиний виводок по бруку перевальцем пройде й пірне у хвилі теплих трав(1) і(2) тишею спекотною між пальців тече сунично-ягідна пора.', 
 '1', 'В. Гей', 
 'Кома 1 відокремлює предикативні частини складносурядного речення перед єднальним сполучником «і».');

-- Варіанти для Вправи 1
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%Качиний виводок%' AND author_name = 'В. Гей' LIMIT 1), '1', true),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Качиний виводок%' AND author_name = 'В. Гей' LIMIT 1), '2', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Качиний виводок%' AND author_name = 'В. Гей' LIMIT 1), '1, 2', false);


-- ПРАВИЛО 23
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
(23, 
 'Визначте місця коми. Про свій перший успіх Лідочка похвалилася тільки мамі(1) а(2) коли з''явилась і друга відмінна оцінка(3) вона не витримала(4) і ввечері показала зошита й татові.', 
 '1', 'В. Лис', 
 'Кома 1 відокремлює сурядні частини. Кома 2 на збігу сполучників «а коли» не ставиться через наявність співвідносного слова далі. Кома 3 виділяє підрядну частину.');

-- Варіанти для Вправи 1
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%Про свій перший успіх%' AND author_name = 'В. Лис' LIMIT 1), '1, 3', true),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Про свій перший успіх%' AND author_name = 'В. Лис' LIMIT 1), '1, 2, 3', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%Про свій перший успіх%' AND author_name = 'В. Лис' LIMIT 1), '1, 3, 4', false);

-- ПРАВИЛО 25
INSERT INTO exercise (rule_id, question, format_type, author_name, detailed_hint) VALUES
-- Вправа 1
(25, 
 'Визначте місце, де потрібно поставити кому між головною та підрядною частиною. А ластівоньці час вирушати аж за море синє(1) бо(2) вже ходять посланці осінні й рукавиці носять про запас.', 
 '1', 'Н. Гуменюк', 
 'Кома 1 відокремлює головну частину від підрядної причини, яка приєднується підрядним сполучником «бо».'),
-- Вправа 2
(25, 
 'Визначте місце коми перед підрядною частиною у складному реченні. А хіба пташка завжди тільки в небі літає? Часом вона й на землю опускається(1) щоб(2) крила перепочили.', 
 '1', 'Н. Гуменюк', 
 'Друге речення є складнопідрядним. Кома 1 відокремлює підрядну частину мети, введену сполучником «щоб».'),
-- Вправа 3
(25, 
 'Визначте місце розділових знаків. На піщаній(1) лісовій дорозі(2) що в''юнилася між височенними(3) столітніми соснами(4) пришпорили коней.', 
 '1', 'Н. Гуменюк', 
 'Підрядна означальна частина «що в’юнилася...» стоїть усередині головного речення, тому з обох боків відокремлюється комами 2 та 4.'),
-- Вправа 4
(25, 
 'Оберіть речення, де правильно розставлено розділові знаки.', 
 '2', 'Н. Гуменюк', 
 'Перша кома відокремлює сурядні частини перед сполучником «а», а друга — підрядну частину причини перед сполучником «бо».'),
-- Вправа 5
(25, 
 'Оберіть варіант речення без пукнтуаційних помилок.', 
 '2', 'В. Лис', 
 'Кома після «голоси» розділяє однорідні додатки, а кома після «сміх» відокремлює підрядну означальну частину.'),
-- Вправа 6
(25, 
 'Оберіть речення, у якому правильно оформлено багатокомпонентну конструкцію.', 
 '2', 'Г. Аркушин', 
 'Між підметом і присудком ставиться тире. Підрядна означальна частина («пелюстками якої...») відокремлена комою від головного речення.');

-- Варіанти для Вправи 1
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%ластівоньці час вирушати%' AND author_name = 'Н. Гуменюк' LIMIT 1), '1', true),
((SELECT exercise_id FROM exercise WHERE question LIKE '%ластівоньці час вирушати%' AND author_name = 'Н. Гуменюк' LIMIT 1), '2', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%ластівоньці час вирушати%' AND author_name = 'Н. Гуменюк' LIMIT 1), '1, 2', false);

-- Варіанти для Вправи 2
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%пташка завжди тільки в небі%' AND author_name = 'Н. Гуменюк' LIMIT 1), '1', true),
((SELECT exercise_id FROM exercise WHERE question LIKE '%пташка завжди тільки в nebi%' AND author_name = 'Н. Гуменюк' LIMIT 1), '2', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%пташка завжди тільки в небі%' AND author_name = 'Н. Гуменюк' LIMIT 1), '1, 2', false);

-- Варіанти для Вправи 3
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question LIKE '%На піщаній(1) лісовій дорозі(2)%' AND author_name = 'Н. Гуменюк' LIMIT 1), '1, 2, 3, 4', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%На піщаній(1) лісовій дорозі(2)%' AND author_name = 'Н. Гуменюк' LIMIT 1), '2', false),
((SELECT exercise_id FROM exercise WHERE question LIKE '%На піщаній(1) лісовій дорозі(2)%' AND author_name = 'Н. Гуменюк' LIMIT 1), '2, 4', true);

-- Варіанти для Вправи 4
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно розставлено розділові знаки.' AND author_name = 'Н. Гуменюк' LIMIT 1), 'Підпливаєш до берега а вийти не можеш бо хвилі човна назад забрати хочуть.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно розставлено розділові знаки.' AND author_name = 'Н. Гуменюк' LIMIT 1), 'Підпливаєш до берега, а вийти не можеш бо хвилі човна назад забрати хочуть.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, де правильно розставлено розділові знаки.' AND author_name = 'Н. Гуменюк' LIMIT 1), 'Підпливаєш до берега, а вийти не можеш, бо хвилі човна назад забрати хочуть.', true);

-- Варіанти для Вправи 5
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення без пукнтуаційних помилок.' AND author_name = 'В. Лис' LIMIT 1), 'Раптом він почув притишені голоси, тихий дівочий сміх, що розсипався легенькими дзвіночками-горошинками.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення без пукнтуаційних помилок.' AND author_name = 'В. Лис' LIMIT 1), 'Раптом він почув притишені голоси, тихий дівочий сміх що розсипався легенькими дзвіночками-горошинками.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть варіант речення без пукнтуаційних помилок.' AND author_name = 'В. Лис' LIMIT 1), 'Раптом він почув притишені голоси тихий дівочий сміх що, розсипався легенькими дзвіночками-горошинками.', false);

-- Варіанти для Вправи 6
INSERT INTO exercise_option (exercise_id, option_text, is_correct) VALUES
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, у якому правильно оформлено багатокомпонентну конструкцію.' AND author_name = 'Г. Аркушин' LIMIT 1), 'Літературна мова — це запашна пречудова квітка, пелюстками якої є народні говірки.', true),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, у якому правильно оформлено багатокомпонентну конструкцію.' AND author_name = 'Г. Аркушин' LIMIT 1), 'Літературна мова — це запашна пречудова квітка пелюстками якої є народні говірки.', false),
((SELECT exercise_id FROM exercise WHERE question = 'Оберіть речення, у якому правильно оформлено багатокомпонентну конструкцію.' AND author_name = 'Г. Аркушин' LIMIT 1), 'Літературна мова це запашна пречудова квітка пелюстками якої є народні говірки.', false);
