
&НаКлиенте
Процедура ДобавитьВКорзину(Команда)
//	ДобавитьВКорзинуНаСервере();
	ТекущийСписок=ПолучитьТекущийСписок(Элементы);
	Если ТекущийСписок=Неопределено Тогда Возврат; КонецЕсли;

	ОповеститьОВыборе(ПолучитьВыделенныеСтроки());
КонецПроцедуры

Функция ПолучитьВыделенныеСтроки()
	МассивСтрок=новый Массив;
	ТекущийСписок=ПолучитьТекущийСписок(Элементы);
	Если ТекущийСписок=Неопределено Тогда Возврат МассивСтрок; КонецЕсли;
	МассивСтрок=новый Массив;
	Для каждого стр из ТекущийСписок.ВыделенныеСтроки Цикл
		МассивСтрок.Добавить(стр.Груз);
	КонецЦикла;
	Возврат МассивСтрок;
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьВидимость();
	ОбновитьСписки();
	Заголовок=Формат(Параметры.ДатаКалендаря,"ДЛФ=DD");
КонецПроцедуры


Процедура ОбновитьСписки()
	
		ОжидаетДоставки.Параметры.УстановитьЗначениеПараметра("ДатаКалендаря",Параметры.ДатаКалендаря);
		Грузы.Параметры.УстановитьЗначениеПараметра("ДатаСреза",Параметры.ДатаКалендаря);
		Грузы.Параметры.УстановитьЗначениеПараметра("Статус",ПолучитьТекущийСтатус());
		СписокОтПоставщика.Параметры.УстановитьЗначениеПараметра("ДатаСреза",Параметры.ДатаКалендаря);
		РасшифровкаГруза.Параметры.УстановитьЗначениеПараметра("Ссылка",Неопределено);	
		СписокДокументов.Параметры.УстановитьЗначениеПараметра("Груз",Неопределено);

//	РасшифровкаГруза.Параметры.УстановитьЗначениеПараметра("Ссылка",Элементы.Грузы.ТекущиеДанные.Груз);
КонецПроцедуры	


Процедура УстановитьВидимость()
	Для каждого стр из Элементы.ГруппаСтраницы.ПодчиненныеЭлементы Цикл
		стр.Видимость=ложь;
	КонецЦикла;	
	Для каждого стат из Параметры.Статусы Цикл
		Если стат="На складе" Тогда
			Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.НаСкладе.Видимость=Истина;
			Если стат=Параметры.текСтатус Тогда
				Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.НаСкладе
			КонецЕсли;	
		ИначеЕсли стат="Сформирвана заявка в ТК" Тогда
			Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ЗаявкаВТК.Видимость=Истина;
			Если стат=Параметры.текСтатус Тогда
				Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ЗаявкаВТК
			КонецЕсли;	
		ИначеЕсли стат="Выехал с точки" Тогда
			Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.Выехал.Видимость=Истина;
			Если стат=Параметры.текСтатус Тогда
				Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.Выехал
			КонецЕсли;	
			
		ИначеЕсли стат="В транспортной компании" Тогда
			Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ВТранспортнойКомпании.Видимость=Истина;
			Если стат=Параметры.текСтатус Тогда
				Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ВТранспортнойКомпании
			КонецЕсли;	
			
		ИначеЕсли стат="Доставлен" Тогда
			Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.Доставлен.Видимость=Истина;
			Если стат=Параметры.текСтатус Тогда
				Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.Доставлен
			КонецЕсли;	
			
		ИначеЕсли стат="Утрачен" Тогда
			Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.Утрачен.Видимость=Истина;
			Если стат=Параметры.текСтатус Тогда
				Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.Утрачен
			КонецЕсли;	
			
		ИначеЕсли стат="Добавлен счет ЭК" Тогда
			Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ЗаявкаВЭК.Видимость=Истина;
			Если стат=Параметры.текСтатус Тогда
				Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ЗаявкаВЭК
			КонецЕсли;	
			
		ИначеЕсли стат="Ожидает доставки" Тогда
			Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.гпОжидаетДоставки.Видимость=Истина;
			Если стат=Параметры.текСтатус Тогда
				Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.гпОжидаетДоставки
			КонецЕсли;	
		ИначеЕсли стат="От поставщика" Тогда
			Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ОтПоставщика.Видимость=Истина;
			Если стат=Параметры.текСтатус Тогда
				Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ОтПоставщика
			КонецЕсли;	
			
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры	




&НаКлиенте
Процедура РасшифроватьГруз()
	ТекущийСписок=ПолучитьТекущийСписок(Элементы);
	Если ТекущийСписок=Неопределено Тогда Возврат; КонецЕсли;
	Если ТекущийСписок.ТекущиеДанные<>Неопределено Тогда
		Если ТекущийСписок.ТекущиеДанные.Свойство("Груз") Тогда
			груз=ТекущийСписок.ТекущиеДанные.Груз;
		ИначеЕсли ТекущийСписок.ТекущиеДанные.Свойство("ЗаявкавТК") Тогда
			//груз=ТекущийСписок.ТекущиеДанные.ЗаявкавТК;
			//ОткрытьЗначение(Груз);
			Возврат;
		Иначе
			груз=Неопределено;
		КонецЕсли;
	Иначе
		груз=Неопределено;
	КонецЕсли;	
	РасшифроватьГрузНаСервере(Груз);
КонецПроцедуры	

Процедура РасшифроватьГрузНаСервере(Груз)
	
	РасшифровкаГруза.Параметры.УстановитьЗначениеПараметра("Ссылка",Груз);	
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("Груз",Груз);
КонецПроцедуры	


&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьТекущийСписок(Элементы)
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.НаСкладе Тогда
		Текущийсписок=Элементы.Грузы;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ЗаявкаВТК Тогда
		Текущийсписок=Элементы.Грузы2;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.Выехал Тогда
		Текущийсписок=Элементы.Грузы3;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ЗаявкаВЭК Тогда
		Текущийсписок=Элементы.Грузы1;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ВТранспортнойКомпании Тогда
		Текущийсписок=Элементы.Грузы4;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.Доставлен Тогда
		Текущийсписок=Элементы.Грузы5;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.Утрачен Тогда
		Текущийсписок=Элементы.Грузы6;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.гпОжидаетДоставки Тогда
		Текущийсписок=Элементы.ОжидаетДоставки;
	Иначе
		Возврат неопределено;
	КонецЕсли;	
	Возврат Текущийсписок;
КонецФункции 


Функция ПолучитьТекущийСтатус()
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.НаСкладе Тогда
		возврат Перечисления.СтатусыОтправкиГруза.НаСкладе;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ЗаявкаВЭК Тогда
		возврат Перечисления.СтатусыОтправкиГруза.ДобавленСчетЭК;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ЗаявкаВТК Тогда
		возврат Перечисления.СтатусыОтправкиГруза.СформирванаЗаявкаВТК;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.Выехал Тогда
		возврат Перечисления.СтатусыОтправкиГруза.ВыехалСТочки;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ВТранспортнойКомпании Тогда
		возврат Перечисления.СтатусыОтправкиГруза.ВТранспортнойКомпании;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.Доставлен Тогда
		возврат Перечисления.СтатусыОтправкиГруза.Доставлен;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.Утрачен Тогда
		возврат Перечисления.СтатусыОтправкиГруза.Утрачен;
	КонецЕсли;
	Возврат Неопределено;
		
	
КонецФункции	

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ОбновитьСписки();
	РасшифроватьГруз();
КонецПроцедуры

&НаСервере
Процедура ГруппаСтраницыПриСменеСтраницыНаСервере()
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	РасшифроватьГруз();
КонецПроцедуры

&НаКлиенте
Процедура ГрузыПриАктивизацииСтроки(Элемент)
	РасшифроватьГруз();
КонецПроцедуры
