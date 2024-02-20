
#Область Проведение

Процедура ОбработкаПроведения(Отказ, Режим)
	Документы.УпаковатьЗаказы.ПроверитьНаличие(ЭтотОбъект,Отказ);
	
	#Область ПравильноеПроведение
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, Режим);
	Документы.УпаковатьЗаказы.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ДополнительныеСвойства.Вставить("ЭтоНовый",ЭтоНовый());
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	СП_ДвиженияСервер.ОтразитьТранзит(ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьУпакованныеЗаказы(ДополнительныеСвойства, Движения, Отказ);
//	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("Обмен100СПрн", ДополнительныеСвойства, Движения, Отказ);
	#КонецОбласти
	
КонецПроцедуры


#КонецОбласти



Процедура ЗаполнитьПоТочкеНазначения(ОчищатьЗаказы=Ложь)   Экспорт
	Если не ЗначениеЗаполнено(ТочкаНазначения) Тогда
		Возврат;
	КонецЕсли;
	списокПунктовВыдачи = новый СписокЗначений;
	Если ТипЗнч(ТочкаНазначения) = Тип("СправочникСсылка.СегментыПунктовВыдачи") Тогда
		списокПунктовВыдачи.ЗагрузитьЗначения(ТочкаНазначения.ПунктыВыдачи.ВыгрузитьКолонку("ПунктВыдачи"));
	иначе	
		списокПунктовВыдачи.Добавить(ТочкаНазначения);
	КонецЕсли;
	
	Дата=ТекущаяДата();
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	&Подбор КАК Подбор,
		|	ТранзитОстатки.ПокупкаСсылка КАК Покупка,
		|	ТранзитОстатки.Участник КАК Участник,
		|	ТранзитОстатки.МестоХранения КАК МестоХранения,
		|	ТранзитОстатки.Габарит КАК Габарит,
		//|	МАКСИМУМ(ЕСТЬNULL(НегабаритЗначения.Вес, 0)) КАК Вес,
		//|	МАКСИМУМ(ЕСТЬNULL(НегабаритЗначения.объем, 0)) КАК Объем,
		
		|	СУММА(ТранзитОстатки.КоличествоОстаток) КАК КоличествоМест,
		|	СУММА(ВЫБОР
		|			КОГДА ТИПЗНАЧЕНИЯ(ТранзитОстатки.ПокупкаСсылка) = ТИП(Справочник.Коробки)
		|				ТОГДА ТранзитОстатки.ПокупкаСсылка.Количество
		|			ИНАЧЕ ТранзитОстатки.КоличествоОстаток
		|		КОНЕЦ) КАК Количество,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПраздничныеДни.Дата) КАК ПраздничныхДней,
		|	ТранзитОстатки.Партия КАК Партия,
		|	ТранзитОстатки.Точка КАК ТочкаНазначения
		|ПОМЕСТИТЬ пред
		|ИЗ
		|	РегистрНакопления.Транзит.Остатки(&ДатаДокумента, Точка В (&списокПунктовВыдачи)) КАК ТранзитОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПраздничныеДни КАК ПраздничныеДни
		|		ПО (ПраздничныеДни.Дата > ТранзитОстатки.Партия.Дата)
		|			И (ПраздничныеДни.Дата < &ДатаДокумента)
		|			И (НЕ ПраздничныеДни.ПометкаУдаления)
		//|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НегабаритЗначения КАК НегабаритЗначения
		//|		ПО 		ТранзитОстатки.Партия 			= НегабаритЗначения.Регистратор
		//|			И 	ТранзитОстатки.ПокупкаСсылка	= НегабаритЗначения.Покупка
		//|			И 	ТранзитОстатки.Участник 		= НегабаритЗначения.Участник
		//|			И 	ТранзитОстатки.Габарит 			= НегабаритЗначения.Габарит

		|
		|СГРУППИРОВАТЬ ПО
		|	ТранзитОстатки.Габарит,
		|	ТранзитОстатки.МестоХранения,
		|	ТранзитОстатки.ПокупкаСсылка,
		|	ТранзитОстатки.Участник,
		|	ТранзитОстатки.Партия,
		|	ТранзитОстатки.Точка
		|
		|ИМЕЮЩИЕ
		|	СУММА(ТранзитОстатки.КоличествоОстаток) > 0
		|ИНДЕКСИРОВАТЬ ПО
		|	Покупка,
		|	Партия
		
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	пред.Подбор КАК Подбор,
		|	пред.Покупка КАК Покупка,
		|	пред.Участник КАК Участник,
		|	пред.МестоХранения КАК МестоХранения,
		|	пред.Габарит КАК Габарит,
		|	пред.КоличествоМест КАК КоличествоМест,
		|	пред.Количество КАК Количество,
		|	пред.Партия КАК Партия,
		|	пред.ТочкаНазначения КАК ТочкаНазначения,
		
		
		|	ЕСТЬNULL(ДанныеЗаказов.Вес, 0) 						КАК Вес,
		|	ЕСТЬNULL(ДанныеЗаказов.объем, 0) 					КАК Объем,
		|	ЕСТЬNULL(ДанныеЗаказовСайт.БесплатнаяВыдача, Ложь) 	КАК БесплатнаяВыдача,
		|	ДанныеЗаказовСайт.ПерваяТочка 						КАК ПерваяТочка,
		|	ЕСТЬNULL(ДанныеЗаказовСайт.НадбавкаЗаОбработку, 0) 	КАК Надбавка,
		
		
		//|	пред.Вес как Вес,
		//|	пред.Объем как Объем,
		//|	ложь  как БесплатнаяВыдача,
		|	0     как СтоимостьДоставки,
		|	РАЗНОСТЬДАТ(пред.Партия.Дата, &ДатаДокумента, ДЕНЬ)  КАК ВремяХранения,
		|	ЕСТЬNULL(ТарифыСрезПоследних.ЦенаХранения, 0) КАК ЦенаХранения,
		|	ЕСТЬNULL(ТарифыСрезПоследних.СрокХранения, 0) КАК СрокХранения,
		|	ЕСТЬNULL(ТарифыСрезПоследних.Заморозка, ЛОЖЬ) КАК Заморозка,
		|	ЕСТЬNULL(ТарифыСрезПоследних.Штраф, 0) КАК Штраф,
		|	ЕСТЬNULL(ТарифыСрезПоследних.негабарит, ЛОЖЬ) КАК негабарит,
		|	ЕСТЬNULL(ТарифыСрезПоследних.ЦенаЗаКГ, 0) КАК ЦенаЗаКГ,
		|	ЕСТЬNULL(ТарифыСрезПоследних.ЦенаЗаКуб, 0) КАК ЦенаЗаКуб,
		|	ВЫБОР
		|		КОГДА ТарифыСрезПоследних.ЦенаХранения ЕСТЬ NULL
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ТарифУстановлен		
		|ИЗ
		|	пред КАК пред
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеЗаказов КАК ДанныеЗаказов
		|		ПО пред.Покупка = ДанныеЗаказов.Заказ
		|			И пред.Партия = ДанныеЗаказов.Партия
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеЗаказовСайт КАК ДанныеЗаказовСайт
		|		ПО пред.Покупка = ДанныеЗаказовСайт.Заказ
		|			И пред.Партия = ДанныеЗаказовСайт.Партия
		
		
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Тарифы.СрезПоследних КАК ТарифыСрезПоследних
		|		ПО пред.Габарит = ТарифыСрезПоследних.Габарит";
//		|			И (НЕ ТарифыСрезПоследних.Отменен)

	Запрос.УстановитьПараметр("списокПунктовВыдачи", списокПунктовВыдачи);
	Запрос.УстановитьПараметр("ДатаДокумента", Дата);
	Запрос.УстановитьПараметр("Подбор", Константы.ПомечатьЗаказыПриФормированииДокументаВыдачаТранзита.Получить());

	Результат 	= Запрос.Выполнить();
	
	тз = Результат.Выгрузить();
	СП_РаботаСДокументами.РасчитатьСтоимостьХранения(тз);
	
	выборка 	= Результат.Выбрать();
	Если ОчищатьЗаказы Тогда
		Покупки.Очистить();
	КонецЕсли;	
	
	Для каждого Элем из тз Цикл

		стр_покупок = Покупки.Добавить();
		ЗаполнитьЗначенияСвойств(стр_покупок, Элем);
		Стр_Покупок.СтоимостьХранения = элем.СтоимостьИтого;
		//структура_Стоимости 			= СП_РаботаСДокументами.ПолучитьСтоимостьХранения(Выборка,Дата);
		//Стр_Покупок.ВремяХранения     	= структура_Стоимости.ВремяХранения;
		//Стр_Покупок.СтоимостьХранения 	= структура_Стоимости.СтоимостьХранения;
		
		
		стр_покупок.Подбор 				= Ложь;
	КонецЦИкла;	
	СтоимостьИтого	=	Покупки.Итог("СтоимостьХранения");	

КонецПроцедуры 

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если РежимЗаписи=РежимЗаписиДокумента.Проведение Тогда
		НеПомеченныеСтроки=Покупки.НайтиСтроки(Новый Структура("Подбор",ложь));
		Для каждого стр из НеПомеченныеСтроки Цикл
			Покупки.Удалить(стр);
		КонецЦикла
	Конецесли;
	
	Если ЗначениеЗаполнено(Супергруппа) Тогда
		тзПокупки = Покупки.Выгрузить(,"Покупка, Участник");
		колПокупка = тзПокупки.Колонки.Найти("Покупка");
		колПокупка.Имя = "Заказ";
		об = Супергруппа.ПолучитьОбъект();
		об.Состав.Загрузить(тзПокупки);
		Попытка
			об.Записать();
		Исключение
			текстОшибки = ОписаниеОшибки();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("не удалось установить состав супергруппы, "+текстОшибки);
		КонецПопытки;
		
	КонецЕсли
	

КонецПроцедуры


Процедура ПриЗаписи(Отказ)
	// Вставить содержимое обработчика.
КонецПроцедуры

