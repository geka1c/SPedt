
&НаСервере
Процедура ЗаполнитьНаСервере()
	док = РеквизитФормыВЗначение("Объект");
	док.ЗаполнитьДанные();
	ЗначениеВДанныеФормы(док,Объект);
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	Модифицированность = Истина;
	ЗаполнитьНаСервере();
КонецПроцедуры


&НаСервере
Функция  ПросмотрXMLНаСервере(НомерСтроки = Неопределено)
	
	
	об=РеквизитФормыВЗначение("Объект");
	Возврат СтоСПОбмен_Запрос.ВыгрузкаПоступлений_income(об,НомерСтроки);
КонецФункции

&НаКлиенте
Процедура ПросмотрXML(Команда)
	Если Модифицированность Тогда
		Записать(новый Структура("РежимЗаписи",РежимЗаписиДокумента.Запись));
	КонецЕсли;
	//Элементы.Данные.
	хмл_incomes=ПросмотрXMLНаСервере();
	СтоСП_Клиент.Показать_XML(хмл_incomes);

КонецПроцедуры

&НаКлиенте
Процедура ПросмотьXMLпоСтроке(Команда)
	Если Элементы.Данные.ТекущаяСтрока = неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбрана строка");
		Возврат;
	КонецЕсли;	
	НомерСтроки = Объект.Данные.НайтиПоИдентификатору(Элементы.Данные.ТекущаяСтрока).НомерСтроки;
	Если Модифицированность Тогда
		Записать(новый Структура("РежимЗаписи",РежимЗаписиДокумента.Запись));
	КонецЕсли;
	//Элементы.Данные.
	хмл_incomes=ПросмотрXMLНаСервере(НомерСтроки);
	СтоСП_Клиент.Показать_XML(хмл_incomes);

КонецПроцедуры

&НаКлиенте
Процедура ПросмотрПолученногоXML(Команда)
	хмл_incomes = Элементы.Протокол.ТекущиеДанные.ПолученныеДанные;
	СтоСП_Клиент.Показать_XML(хмл_incomes);
КонецПроцедуры




&НаКлиенте
Процедура Отправить(Команда)
	Если Модифицированность Тогда
		Записать(новый Структура("РежимЗаписи",РежимЗаписиДокумента.Запись));
	КонецЕсли;	
	ОтправитьНаСервере();
	//Для каждого пос из Объект.Посылки Цикл
	//	Если пос.Отправлено Тогда
	//		ОповеститьОбИзменении(пос.Посылка);
	//	Конецесли;
	//КонецЦикла	
КонецПроцедуры

&НаСервере
Процедура ОтправитьНаСервере()
	об	=	РеквизитФормыВЗначение("Объект");
	об.ВыгрузитьНаСайт();
	ЗначениеВДанныеФормы(об,Объект);
КонецПроцедуры


&НаКлиенте
Процедура ПоказатьСкрытьОтправлено(Команда)
	Элементы.ГруппаОтправлено.Видимость 	= не Элементы.ГруппаОтправлено.Видимость;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСкрытьЗагружено(Команда)
	Элементы.ГруппаЗагружено.Видимость 	= не Элементы.ГруппаЗагружено.Видимость;
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ГруппаСтраницыПриСменеСтраницыНаСервере()
КонецПроцедуры


&НаСервере
Процедура ГруппаСтраницыПриСменеСтраницыНаСервере()
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница	= Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаПротокол Тогда
		парамДок				= Протокол.Параметры.Элементы.Найти("Документ");
		парамДок.Значение		= Объект.Ссылка;
		парамДок.Использование	= Истина;
	Конецесли;	
КонецПроцедуры

&НаКлиенте
Процедура ДвиженияПриходной(Команда)
	ДвиженияПриходнойНасЕрвере();
КонецПроцедуры

Процедура ДвиженияПриходнойНасЕрвере()
	об	=	РеквизитФормыВЗначение("Объект");
	об.СформироватьДвиженияРазбораКоробкиПоДаннымЗаказа();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
	
	
	Если  Объект.СтрокВПакете = 0 Тогда
		Объект.СтрокВПакете = 500
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ОчисткаДанныхЗАказовУдалитьНаСервере()
	Модифицированность = Истина;
	об = РеквизитФормыВЗначение("Объект");
	об.ОчиститьДанныеПосылок();
	ЗначениеВДанныеФормы(об,Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОчисткаДанныхЗАказовУдалить(Команда)
	ОчисткаДанныхЗАказовУдалитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НакладныеПриАктивизацииСтроки(Элемент)
	Если Элемент.текущиеДанные	= неопределено Тогда Возврат; КонецЕсли;
	Элементы.Данные.ОтборСтрок	= новый ФиксированнаяСтруктура("Партия",Элемент.текущиеДанные.Партия);
КонецПроцедуры

&НаКлиенте
Процедура СнятьФильтры(Команда)
	Элементы.Данные.ОтборСтрок	= Неопределено;
КонецПроцедуры




// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

&НаКлиенте
Процедура РасчитатьЗаголовки(Команда)
	//расчет заголовков страниц заказов
	всегоПокупок = Объект.Покупки.Количество();
	Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.группаПокупки.Заголовок=?(всегоПокупок=0,"Покупки","Покупки ("+всегоПокупок+")");
	
	всегоПосылок = Объект.Посылки.Количество();
	Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.группаПосылки.Заголовок=?(всегоПосылок=0,"Посылки","Посылки ("+всегоПосылок+")");

	всегоГруппНаТранзит = Объект.ГруппыНаТранзит.Количество();
	Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаГруппыНаТранзит.Заголовок=?(всегоГруппНаТранзит=0,"Группы на транзит","Группы на транзит ("+всегоГруппНаТранзит+")");
	

КонецПроцедуры

&НаКлиенте
Процедура ПосылкиГабаритПриИзменении(Элемент)
	ГабвритПараметры =  СП_РаботаСДокументами.ГабаритПараметры(Элементы.Посылки.ТекущиеДанные.Габарит);
	Если ГабвритПараметры = Неопределено Тогда
		Элементы.Посылки.ТекущиеДанные.Габарит =Неопределено;
	ИначеЕсли ГабвритПараметры.Отменен Тогда	
		Элементы.Посылки.ТекущиеДанные.Габарит =Неопределено;
	ИначеЕсли ГабвритПараметры.ЛимитПревышен Тогда
		ТекстСообщения = "Принято максимальное количество заказов по габариту "+ Элементы.Посылки.ТекущиеДанные.Габарит +" , "+ГабвритПараметры.Лимит +"шт";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Элементы.Посылки.ТекущиеДанные.Габарит =Неопределено;

	КонецЕсли;	
	
	
	Объект.Отправлено = Ложь;
	Элементы.Посылки.ТекущиеДанные.отправлено = Ложь;

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
КонецПроцедуры

&НаКлиенте
Процедура НакладныеПередУдалением(Элемент, Отказ)
	масс_Поиска = Объект.Данные.НайтиСтроки(Новый Структура("Партия",Элемент.ТекущиеДанные.Партия));
	Для каждого элем из масс_Поиска Цикл
		 Объект.Данные.Удалить(элем.НомерСтроки-1);	
	КонецЦикла;	

КонецПроцедуры





// Конец СтандартныеПодсистемы.ПодключаемыеКоманды



