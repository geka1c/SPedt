
&НаКлиенте
Процедура СписокДатаВремяВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.СписокАдресов.ТекущиеДанные = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбран адрес");
		Возврат;
	КонецЕсли;	
	Если Элементы.СписокДатаВремя.ТекущиеДанные = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбраны дата и время вызова курьера!");
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ДокументОтправления) Тогда	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбран документ отправления!");
		Возврат;
	КонецЕсли;


	
	Адрес = Элементы.СписокАдресов.ТекущиеДанные.Адрес;
	ИдАдреса = Элементы.СписокАдресов.ТекущиеДанные.ИдАдреса;
	
	ДатаВызоваКурьера = Элементы.СписокДатаВремя.ТекущиеДанные.Дата;
	ВремяВызоваКурьера = Элементы.СписокДатаВремя.ТекущиеДанные.Время;
	ИдДатаВремя = Элементы.СписокДатаВремя.ТекущиеДанные.ИдДатаВремя;
	МассивПартий = Новый Массив();
	МассивПартий.Добавить(НомерПартии);
	
	ПараметрыЗаявки = Новый Структура;
	ПараметрыЗаявки.Вставить("ДокументОтправления",ДокументОтправления);
	ПараметрыЗаявки.Вставить("Адрес",Адрес);
	ПараметрыЗаявки.Вставить("ИдАдреса",ИдАдреса);
	ПараметрыЗаявки.Вставить("МассивПартий",МассивПартий);
	ПараметрыЗаявки.Вставить("КонтактноеЛицо","Олеся Александровна Снеткова");
	ПараметрыЗаявки.Вставить("КонтактныйТелефон","+79502929482");
	ПараметрыЗаявки.Вставить("ДатаВызоваКурьера",ДатаВызоваКурьера);
	ПараметрыЗаявки.Вставить("ИдДатаВремя",Формат(Число(ИдДатаВремя),"ЧГ=0;"));
	ПараметрыЗаявки.Вставить("ЭтоЕМС",Ложь);
	Протокол = Интеграция_ПочтаРоссии.ОформитьЗаявкуНаВызовКурьера(ПараметрыЗаявки);
	Протокол.Вставить("Адрес",Адрес);
	Протокол.Вставить("ДатаВызоваКурьера",ДатаВызоваКурьера);
	Протокол.Вставить("ВремяВызоваКурьера",ВремяВызоваКурьера);
	Закрыть(Протокол);
КонецПроцедуры

&НаКлиенте
Процедура СписокАдресовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбратьАдрес();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если не ЗначениеЗаполнено(Параметры.ПунктВыдачи) Тогда
		ПунктВыдачи = Справочники.ТочкиРаздачи.НайтиПоКоду("0020");	 //ПочтаРоссии	
	Иначе	
		ПунктВыдачи = Параметры.ПунктВыдачи;
	КонецЕсли;	
	НомерПартии = Параметры.НомерПартии;
	ДокументОтправления = Параметры.ДокументОтправления;
КонецПроцедуры


&НаКлиенте
Процедура Выбрать(Команда)
	//ВыбратьИЗакрыть()
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьАдрес()
	текД = Элементы.СписокАдресов.ТекущиеДанные;
	Если Элементы.СписокАдресов.ТекущиеДанные = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Выберите адрес вызова курьера");
		Возврат;
	КонецЕсли;
	результат = новый Структура("address_id, address",текД.ИдАдреса, текД.Адрес);
	стрОтвета = Интеграция_ПочтаРоссии.ПолучитьДатыВремяВызоваКурьера(Результат.address_id);
	СписокДатаВремя.Очистить();
	Для Каждого элемДата Из стрОтвета.Варианты[0].addressdates Цикл
		Для Каждого элемВремя Из элемДата.timeintervals Цикл
			новыйВариант = СписокДатаВремя.Добавить();
			новыйВариант.Дата =элемДата.arrivaldate;
			новыйВариант.Время = элемВремя.timeintervaldesc;
			новыйВариант.ИдДатаВремя =элемВремя.timeintervalid;
		КонецЦикла;
	КонецЦикла;	
	//Закрыть(результат);
КонецПроцедуры	

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗначениеЗаполнено(ПунктВыдачи) Тогда
		стрОтвета = Интеграция_ПочтаРоссии.ПолучитьАдресаВызоваКурьера(ПунктВыдачи);
		Для Каждого адрес Из стрОтвета.Адреса Цикл
			новыйАдрес = СписокАдресов.Добавить();
			новыйАдрес.Адрес = адрес.address;
			новыйАдрес.ИдАдреса = адрес.addressid;	
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры
