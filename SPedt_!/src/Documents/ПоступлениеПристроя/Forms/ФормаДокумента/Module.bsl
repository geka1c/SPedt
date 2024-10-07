&НаКлиенте
Процедура РазрешитьРедактирование(Команда)
//	ОткрытьФорму("ОбщаяФорма.ФормаОжиданиеВводаШтрихкода",,ЭтотОбъект,,,,Новый ОписаниеОповещения("ВвестиШтрихКодАдминистратора_Завершение", ЭтотОбъект),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
		ТолькоПросмотр 									= Ложь;
		Элементы.Заказы.ТолькоПросмотр 					= Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвратОплатыКартой(Команда)
	ОчиститьСообщения();
	Если Не Объект.ОплатаВыполнена Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр(
			"ru='Для данного документа не выполнена оплата платежной картой.'"));
		Возврат;
	КонецЕсли;
	Оповещение = Новый ОписаниеОповещения("ВозвратОплатыКартойЗавершение", ЭтотОбъект);
	ТекстВопроса = "Вы уверенны что необходимо Вернуть оплату по карте?";
	ПоказатьВопрос(Оповещение, ТекстВопроса , РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвратОплатыКартойЗавершение(Результат, ДопаолнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	Конецесли;

	Сумма = Объект.СтоимостьИтого;

	ПараметрыОперации=МенеджерОборудованияКлиент.ПараметрыВыполненияЭквайринговойОперации();
	ПараметрыОперации.ТипТранзакции		= "AuthorizeRefund";
	ПараметрыОперации.СуммаОперации 	= Сумма;
	ПараметрыОперации.НомерЧека			= "";
	ПараметрыОперации.НомерЧекаЭТ		= "";
	ПараметрыОперации.НомерКарты		= Объект.НомерКарты;
	ПараметрыОперации.СсылочныйНомер 	= Объект.СсылочныйНомер;
	МенеджерОборудованияКлиент.ПредложитьВыбратьУстройство(
		Новый ОписаниеОповещения("ОплатитьКартойПредложитьВыбратьЭквайринговыйТерминалЗавершение", ЭтотОбъект,
		ПараметрыОперации), "ЭквайринговыйТерминал", НСтр("ru='Выберите эквайринговый терминал'"), НСтр(
		"ru='Эквайринговый терминал не подключен'"));
	
КонецПроцедуры


&НаКлиенте
Процедура ЧекОтмены(Команда)
	Если Объект.СтатусККМ <> ПредопределенноеЗначение("Перечисление.СтатусыЧековККМ.Фискализирован") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Отменить можно только фискализарованный чек!");
		возврат;
	КонецЕсли;	
	
	данныеформы				= Объект;
	ОбщиеПараметры = СП_ККТ.ПолучитьШаблонЧекаКоррекции(УстройствоПечати, данныеформы);
	
	
	Оповещение = Новый ОписаниеОповещения("НапечататьЧекКоррекции_Завершение", ЭтотОбъект, ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьФормированиеЧекаКоррекцииНаФискальномУстройстве(Оповещение, УникальныйИдентификатор, ОбщиеПараметры, ?(УстройствоПечати.Пустая(), Неопределено, УстройствоПечати)); 
	
КонецПроцедуры


&НаКлиенте
Процедура 	НапечататьЧекКоррекции_Завершение(РезультатВыполнения, Параметры) Экспорт 


	//ЭтаФорма.Доступность = Истина;
	//Если РезультатВыполнения.Результат Тогда
	//	Объект.НомерСменыККМ = РезультатВыполнения.ВыходныеПараметры[0];
	//	Объект.НомерЧекаККМ  = РезультатВыполнения.ВыходныеПараметры[1];
	//	Объект.Статус 		 = ПредопределенноеЗначение("Перечисление.СтатусыЧековККМ.Фискализирован");
	//	Объект.Дата   		 = МенеджерОборудованияКлиентПереопределяемый.ДатаСеанса();
	//	Если Не ЗначениеЗаполнено(Объект.НомерЧекаККМ) Тогда
	//		Объект.НомерЧекаККМ = 1;
	//	КонецЕсли;
	//		
	//	СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(ЭтотОбъект);
	//Иначе
	//	ТекстСообщения = НСтр("ru = 'При выполнении операции произошла ошибка:""%ОписаниеОшибки%"".'");
	//	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", РезультатВыполнения.ОписаниеОшибки);
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект.Ссылка);
	//КонецЕсли;
	
КонецПроцедуры




&НаКлиенте
Процедура ОтменаОплатыКартой(Команда)
	ОчиститьСообщения();
	Если не Объект.ОплатаВыполнена Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Для данного документа не выполнена оплата платежной картой.'"));
		Возврат;
	КонецЕсли;
	Оповещение = Новый ОписаниеОповещения("ОтменаОплатыКартойЗавершение", ЭтотОбъект);
	ТекстВопроса = "Вы уверенны что необходимо отменить оплату по карте?";
	ПоказатьВопрос(Оповещение, ТекстВопроса , РежимДиалогаВопрос.ДаНет);
КонецПроцедуры


&НаКлиенте
Процедура ОтменаОплатыКартойЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;

	Сумма = Объект.СтоимостьИтого;

	ПараметрыОперации=МенеджерОборудованияКлиент.ПараметрыВыполненияЭквайринговойОперации();
	ПараметрыОперации.ТипТранзакции		= "AuthorizeVoid";
	ПараметрыОперации.СуммаОперации 	= Сумма;
	ПараметрыОперации.НомерЧека			= "";
	ПараметрыОперации.НомерЧекаЭТ		= "7";
	ПараметрыОперации.НомерКарты		= Объект.НомерКарты;
	ПараметрыОперации.СсылочныйНомер 	= Объект.СсылочныйНомер;
	МенеджерОборудованияКлиент.ПредложитьВыбратьУстройство(
		Новый ОписаниеОповещения("ОплатитьКартойПредложитьВыбратьЭквайринговыйТерминалЗавершение", ЭтотОбъект,
		ПараметрыОперации), "ЭквайринговыйТерминал", НСтр("ru='Выберите эквайринговый терминал'"), НСтр(
		"ru='Эквайринговый терминал не подключен'"));
КонецПроцедуры




&НаКлиенте
Процедура ВвестиШтрихКодАдминистратора_Завершение(ШК, ДополнительныеПараметры) Экспорт
	//Если ТипЗнч(ШК) =  Тип("Структура") и
	//	 ШК.Свойство("Администратор")	и
	//	 ШК.Администратор         			Тогда
		ТолькоПросмотр 									= Ложь;
		Элементы.Заказы.ТолькоПросмотр 					= Ложь;
	// КонецЕсли;	 
КонецПроцедуры	




#Область ШтрихКоды

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// ПодключаемоеОборудование
	Если 	ИмяСобытия 	= "ScanData" 					и
			Источник 	= "ПодключаемоеОборудование" 	и
			Параметр.Найти("Обработано") 	= Неопределено и
			ВводДоступен()										Тогда
			
			ШК 			= СтоСП_Клиент.ПолучитьШКизПараметров(Параметр);
			ОбработатьШКнаКлиенте(ШК);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШКнаКлиенте(ШК)
	Если ШК = неопределено тогда Возврат КонецЕсли;
	ДанныеШК    = СП_Штрихкоды.ПолучитьДанныеПоШК(ШК);
	Модифицированность = истина;
	Если 		Строка(ДанныеШК.Тип) = "Посылка (12)" 				Тогда
		Если Элементы.ГруппаСтраницы.ТекущаяСтраница = элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаЗаявкиНаДоставку Тогда
			СтрокаЗаказа	=	Элементы.ЗаявкиНаДоставку.ТекущиеДанные;
		ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаПристрой Тогда	
			СтрокаЗаказа	=	Элементы.Заказы.ТекущиеДанные;
		Иначе	
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Что бы назначить штрих код, Выберите заявку на доставку или пистрой!");
			Возврат;
		КонецЕсли;	
		Если СтрокаЗаказа = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Установите курсор на строку с пристроем, для привязки стикера");
			Возврат;
		КонецЕсли;	
		Если ЗначениеЗаполнено(СтрокаЗаказа.ШК) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Уже привязан штрих код:"+СтрокаЗаказа.ШК);
			Возврат;
		КОнецЕсли;	
		СтрокаЗаказа.МестоХранения	= МестоХранения;
		СтрокаЗаказа.Габарит		= Габарит;
		СтрокаЗаказа.ШК				= ДанныеШК.ШК;
		
			#Если не ВебКлиент Тогда
			Сигнал();
			#КонецЕсли
	ИначеЕсли 	Строка(ДанныеШК.Тип) 	= "Карта участника (22)"	или
		 Строка(ДанныеШК.Тип) 	= "Карта участника (23)"			Тогда
			Объект.Участник	= ДанныеШК.Участник;
			ОбновитьСписокПристроя();
	ИначеЕсли Строка(ДанныеШК.Тип) = "Габарит (62)" 				Тогда	
		Габарит			= ДанныеШК.Габарит;
	ИначеЕсли Строка(ДанныеШК.Тип) = "Место хранения (63)" 		Тогда	
		МестоХранения	= ДанныеШК.МестоХранения;
	ИначеЕсли 	Строка(ДанныеШК.Тип) 		= "Сотрудник (55)" 			Тогда	
		Если СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(этотОбъект,,ДанныеШК.Сотрудник) Тогда
			Закрыть();
		КонецЕсли;				
	КонецЕсли;		
КонецПроцедуры


#КонецОбласти



#Область ОбменДанными

&НаСервере
Функция  ПросмотрXMLНаСервере()
	
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ПоступлениеПристроя"));
	Возврат об.СкомпоноватьДляВыгрузки();
КонецФункции

&НаКлиенте
Процедура ПросмотрXML(Команда)
	Если Модифицированность Тогда
		Записать(новый Структура("РежимЗаписи",РежимЗаписиДокумента.Запись));
	КонецЕсли;
	хмл_incomes=ПросмотрXMLНаСервере();
	СтоСП_Клиент.Показать_XML(хмл_incomes);
КонецПроцедуры

&НаКлиенте
Процедура ПросмотрПолученногоXML(Команда)
	хмл_incomes = Элементы.Протокол.ТекущиеДанные.ПолученныеДанные;
	СтоСП_Клиент.Показать_XML(хмл_incomes);
КонецПроцедуры



&НаКлиенте
Процедура Отправить(Команда)
	Если ЕстьНеЗаполненыйШК() Тогда Возврат КонецЕсли;; 
	Если Модифицированность Тогда
		Записать(новый Структура("РежимЗаписи",РежимЗаписиДокумента.Запись));
	КонецЕсли;	
	ОтправитьНаСервере();
	Для каждого стр из Объект.Заказы Цикл
		Если стр.Отправлено Тогда
			ОповеститьОбИзменении(стр.Пристрой);
		Конецесли;
	КонецЦикла;
	Для каждого стр из Объект.ЗаявкиНаДоставку Цикл
		Если стр.Отправлено Тогда
			ОповеститьОбИзменении(стр.заявка);
		Конецесли;
	КонецЦикла;
	
	ПересчитатьСумму();
КонецПроцедуры

&НаКлиенте
Функция ЕстьНеЗаполненыйШК()
	отказ = Ложь;		
	
	Если объект.ПечатаемСтикер Тогда
//		ТекстВопроса = "Будет привязано:"+символы.ПС;
//		КоличествоПристроя = 0;
//		КоличествоЗаявок = 0;
//		
//		Для Каждого элем из объект.Заказы Цикл
//			Если не ЗначениеЗаполнено(элем.шк) Тогда
//				КоличествоПристроя = КоличествоПристроя +1;
//			КонецЕсли;	
//		КонецЦикла;	
//		Для Каждого элем из объект.ЗаявкиНаДоставку Цикл
//			Если не ЗначениеЗаполнено(элем.шк) Тогда
//				КоличествоЗаявок = КоличествоЗаявок +1;
//			КонецЕсли;	
//		КонецЦикла;	
//		Если КоличествоПристроя>0 Тогда
//			ТекстВопроса = ТекстВопроса + "Пристрой - "+ КоличествоПристроя + "шт."+Символы.ПС;
//		КонецЕсли;
//		Если КоличествоЗаявок>0 Тогда
//			ТекстВопроса = ТекстВопроса + "Заявок - "+ КоличествоЗаявок+ "шт."+Символы.ПС;
//		КонецЕсли;
//		Если КоличествоПристроя>0 или КоличествоЗаявок>0 Тогда
//			ТекстВопроса = ТекстВопроса + "Продолжить?";
//			Ответ = Вопрос(ТекстВопроса,РежимДиалогаВопрос.ДаНет);
//			Если Ответ = КодВозвратаДиалога.Нет Тогда
//				Отказ = Истина
//		    КонецЕсли;
//		КонецЕсли;
		
	Иначе	
		Для каждого элем из объект.ЗаявкиНаДоставку Цикл
			Если не ЗначениеЗаполнено(элем.шк) Тогда
				ИндексСтроки = элем.Номерстроки-1;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Необходимо привязать штрих код к заказу в строке "+элем.Номерстроки,,"ЗаявкиНаДоставку["+ИндексСтроки+"].ШК","Объект",отказ);
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;
	Возврат отказ;
КонецФункции


&НаСервере
Процедура ОтправитьНаСервере()
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ПоступлениеПристроя"));
	об.ВыгрузитьНаСайт();
	ЗначениеВДанныеФормы(об,Объект);
КонецПроцедуры



&НаКлиенте
Процедура ОбновитьССайта(Команда)
	Если не ЗначениеЗаполнено(объект.Участник) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Необходимо выбрать участника!",,"Участник","Объект");
		Возврат;
	КонецЕсли;	
	ОбновитьСписокПристроя();
	ПересчитатьСумму();
	РасчитатьЗаголовки();
	Модифицированность = истина;
КонецПроцедуры

Процедура ОбновитьСписокПристроя()
	Попытка
		ПолученоССайта = СтоСПОбмен_Пристрой.Загрузить_ПристройПоУчастнику(Объект.Участник);
		об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ПоступлениеПристроя"));
		//об.ЗаполнитьНеПринятыми();
		об.ЗаполнитьЗагруженными(ПолученоССайта, МестоХранения, Габарит);
		ЗначениеВДанныеФормы(об,Объект);
		
	Исключение
		ТекстОшибки = ОписаниеОшибки();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	КонецПопытки;
	
КонецПроцедуры



&НаКлиенте
Процедура 		ПросмотрПристроя(Команда)
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаЗаявкиНаДоставку Тогда
		СтрокаЗаказа	=	Элементы.ЗаявкиНаДоставку.ТекущиеДанные.Заявка;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаПристрой Тогда	
		СтрокаЗаказа	=	Элементы.Заказы.ТекущиеДанные.Пристрой;
	Иначе	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("необходимо выбрать заявку на доставку или пистрой!");
		Возврат;
	КонецЕсли;	
	путьПристроя=ПолучитьПутьПристроя(СтрокаЗаказа);
	ЗапуститьПриложение(путьПристроя);
 КонецПроцедуры

 Функция 		ПолучитьПутьПристроя(Пристрой)
	Если ТипЗнч(Пристрой) = Тип("СправочникСсылка.Пристрой") Тогда
		путьПристроя="http://www.100sp.ru/bulletins/"+Формат(Пристрой.bulletinId,"ЧГ=0");
	Иначе
		путьПристроя="http://www.100sp.ru/externalOrder/"+Формат(Пристрой.bulletinId,"ЧГ=0");	
	КонецЕсли;	
	Возврат путьПристроя;
КонецФункции	


Процедура 		ОтвязатьПристройНаСервере(Пристрой) Экспорт
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ПоступлениеПристроя"));
	об.ОтвязатьПристройОтПосылки(Пристрой);
	ЗначениеВДанныеФормы(об,Объект);	
	Записать(новый структура("РежимЗаписи",РежимЗаписиДокумента.Запись));
КонецПроцедуры

&НаКлиенте
Процедура 	ОтвязатьПристройЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	Если Ответ =  КодВозвратаДиалога.да тогда
		ОтвязатьПристройНаСервере(ДополнительныеПараметры.Пристрой)
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура 		ОтвязатьПристрой(Команда)
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаЗаявкиНаДоставку Тогда
		СтрокаЗаказа	=	Элементы.ЗаявкиНаДоставку.ТекущиеДанные.Заявка;
		ТекущиеДанные	=	Элементы.ЗаявкиНаДоставку.ТекущиеДанные;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаПристрой Тогда	
		СтрокаЗаказа	=	Элементы.Заказы.ТекущиеДанные.Пристрой;
		ТекущиеДанные	=	Элементы.Заказы.ТекущиеДанные;
	Иначе	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("необходимо выбрать заявку на доставку или пистрой!");
		Возврат;
	КонецЕсли;	
	Оповещение = Новый ОписаниеОповещения("ОтвязатьПристройЗавершение",ЭтотОбъект,Новый Структура("Пристрой",СтрокаЗаказа));
	ПоказатьВопрос(Оповещение,"Заказ "+СтрокаЗаказа+" будет отвязан от штрих кода: "+ ТекущиеДанные.ШК+". Продолжить?",РежимДиалогаВопрос.ДаНет); 
	
	
	//Если Вопрос("Вы дествительно хотите отвязать данный пристройот стикера?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
	//	ОтвязатьПристройНаСервере(Элементы.Заказы.ТекущиеДанные.Пристрой);
	//КонецЕсли;	
	//ПараметрыЗаписи = Новый Структура("РежимЗаписи",
	//										РежимЗаписиДокумента.Запись);

	//СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(ЭтотОбъект, ПараметрыЗаписи);
КонецПроцедуры


#КонецОбласти


#Область ФискальныйЧек

&НаКлиенте
Процедура 	ФискализироватьЧекАвтоПослеЗаписи()
	Сумма 		= Объект.СтоимостьИтого;
	
	ДанныеФормы	= Объект;
	Если Сумма=0 тогда Возврат КонецЕсли;
	Если 	ПроверитьЗаполнениеДокумента()	и 
			ПроверитьЗаполнение() 			и  
			СП_ККТ.НужноПечататьЧек(ДанныеФормы)  	Тогда
		
		ОчиститьСообщения();
		
		Если Объект.СтатусККМ <> ПредопределенноеЗначение("Перечисление.СтатусыЧековККМ.Фискализирован") Тогда
			ФискализацияЧека();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФискализироватьЧек(Команда)
	Записать( Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
	Если 	ПроверитьЗаполнениеДокумента() и 
			ПроверитьЗаполнение() 				Тогда
		
		ОчиститьСообщения();
		Если Объект.СтатусККМ <> ПредопределенноеЗначение("Перечисление.СтатусыЧековККМ.Фискализирован") Тогда
			ФискализацияЧека(Истина);
		Иначе
			ТекстПредупреждения = НСтр("ru = 'Чек уже фискализирован на фискальном устройстве'");
			ПоказатьПредупреждение( , ТекстПредупреждения, 10);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура 	ФискализацияЧека(Печатать =  Ложь) Экспорт
	ЭтаФорма.Доступность 	= Ложь;
	
	данныеформы				= Объект;
	ОбщиеПараметры 		 	= СП_ККТ.ПолучитьШаблонЧека(УстройствоПечати, данныеформы,Печатать);
	ОписаниеОповещения 		= Новый ОписаниеОповещения("ФискализацияЧека_Завершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьФискализациюЧекаНаФискальномУстройстве(ОписаниеОповещения, УникальныйИдентификатор, ОбщиеПараметры, ?(УстройствоПечати.Пустая(), Неопределено, УстройствоПечати));
КонецПроцедуры


&НаКлиенте
Процедура 	ФискализацияЧека_Завершение(РезультатВыполнения, Параметры) Экспорт
	ЭтаФорма.Доступность = Истина;
	Если РезультатВыполнения.Результат Тогда
		Объект.НомерСменыККМ = РезультатВыполнения.ВыходныеПараметры[0];
		Объект.НомерЧекаККМ  = РезультатВыполнения.ВыходныеПараметры[1];
		Объект.СтатусККМ	 = ПредопределенноеЗначение("Перечисление.СтатусыЧековККМ.Фискализирован");
		Объект.Дата   		 = МенеджерОборудованияКлиентПереопределяемый.ДатаСеанса();
		Если Не ЗначениеЗаполнено(Объект.НомерЧекаККМ) Тогда
			Объект.НомерЧекаККМ = 1;
		КонецЕсли;
			
		СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(ЭтотОбъект);
	Иначе
		ТекстСообщения = НСтр("ru = 'При выполнении операции произошла ошибка:""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Эквайринг
&НаКлиенте
Процедура ОплатитьКартой(Команда)
	ВидОплаты = ПредопределенноеЗначение("Перечисление.ФормыОплаты.ПлатежнаяКарта");
	ПроверитьИОплатить(ВидОплаты);
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьБезнал(ВидОперации)

	Если Объект.НомерЧекаККМ <> 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Уже распечатан фискальняй чек. Оплата не выполнена!");
		Возврат;
	КонецЕсли;	
	
	
	Если не  ПроверитьЗаполнение() Тогда Возврат; КонецЕсли;

	Сумма 				= Объект.СтоимостьИтого;//Объект.Покупки.Итог("СтоимостьИтого")+Объект.ПоискНикаСтоимость;
	Объект.ВидОплаты 	= ВидОперации;
	ОчиститьСообщения();

	Если Объект.ОплатаВыполнена Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Для данного документа уже выполнена оплата платежной картой.'"));
		Возврат;
	КонецЕсли;

		ПараметрыОперации					= МенеджерОборудованияКлиент.ПараметрыВыполненияЭквайринговойОперации();
		ПараметрыОперации.ТипТранзакции		= "AuthorizeSales";
		ПараметрыОперации.СуммаОперации 	= Сумма;
		ПараметрыОперации.НомерЧека			= "";
		ПараметрыОперации.СсылочныйНомер 	= "";

	МенеджерОборудованияКлиент.ПредложитьВыбратьУстройство(
		Новый ОписаниеОповещения("ОплатитьКартойПредложитьВыбратьЭквайринговыйТерминалЗавершение", ЭтотОбъект, ПараметрыОперации),
		"ЭквайринговыйТерминал",
		НСтр("ru='Выберите эквайринговый терминал'"),
		НСтр("ru='Эквайринговый терминал не подключен'"));

КонецПроцедуры



&НаКлиенте
Процедура ОплатитьКартойПредложитьВыбратьЭквайринговыйТерминалЗавершение(ИдентификаторУстройстваЭТ, ПараметрыОперации) Экспорт
	
	Если ИдентификаторУстройстваЭТ <> Неопределено Тогда
		
		ЭтаФорма.Доступность=Ложь;
		
		Оповещение = новый ОписаниеОповещения("ОплатитьКартойЗавершение", ЭтотОбъект);
		МенеджерОборудованияКлиент.НачатьВыполнениеОперацииНаЭквайринговомТерминале(Оповещение,УникальныйИдентификатор,
			ИдентификаторУстройстваЭТ,, ПараметрыОперации);	
		
		
		ОписаниеОшибки = "";
		РезультатЭТ = МенеджерОборудованияКлиент.ПодключитьОборудованиеПоИдентификатору(УникальныйИдентификатор,
		                                                                                ИдентификаторУстройстваЭТ,
		                                                                                ОписаниеОшибки);
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ОплатитьКартойЗавершение(Результат, ДополнительныеПараметры) Экспорт
	ЭтаФорма.Доступность = Истина;
	Если Результат.Результат Тогда
		Если 		Результат.ТипТранзакции = "AuthorizeSales" Тогда
			Объект.ОплатаВыполнена 	= Истина;
			Объект.СсылочныйНомер 	= Результат.СсылочныйНомер;
			Объект.НомерКарты 		= Результат.НомерКарты;
			//ФискализироватьЧекАвтоПослеЗаписи();
		ИначеЕсли 	Результат.ТипТранзакции = "AuthorizeVoid" или 
					Результат.ТипТранзакции = "AuthorizeRefund" Тогда
			Объект.ОплатаВыполнена 	= Ложь;
			Объект.СсылочныйНомер 	= Результат.СсылочныйНомер;
			Объект.НомерКарты 		= Результат.НомерКарты;
			Объект.ВидОплаты 		= ПредопределенноеЗначение("Перечисление.ФормыОплаты.Наличные");
			
		КонецЕсли;
		Если СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(ЭтотОбъект) Тогда
			Если Результат.ТипТранзакции = "AuthorizeSales" Тогда
				ПослеОплаты();
			КонецЕсли;
		КонецЕсли;
	Иначе
		Сообщить("При выполнении операции произошла ошибка "+Результат.ОписаниеОшибки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеОплаты()
	
	СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(ЭтотОбъект);
	
	ОповеститьОбИзменении(Объект.Ссылка);
	ФискализироватьЧекАвтоПослеЗаписи();
	УстановитьВидимость();
	Если ЗакрытьПослеОплаты Тогда
		Закрыть();
	КонецЕсли;	
КонецПроцедуры	

#КонецОбласти



#Область СобытияФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
	ИспользоватьПодключаемоеОборудование 	= ПодключаемоеОборудованиеВызовСервера.ИспользоватьПодключаемоеОборудование();
	УстройствоПечати 						= ПодключаемоеОборудованиеВызовСервера.ВернутьИдентификаторУстройстваДляПечатиДокументов();
	
	Если Параметры.Свойство("Участник") Тогда
		Объект.Участник = Параметры.Участник;
	КонецЕсли;	
	
	Если не ЗначениеЗаполнено(Объект.СвояТочка) Тогда
		Объект.СвояТочка=константы.СвояТочка.Получить();
	КонецЕсли;	
	Умолчания			= аСПНаСервере.ПолучитьЗначенияПоУмолчанию();
	Габарит				= Умолчания.Габарит;
	МестоХранения		= Умолчания.МестоХранения;
	ЗакрытьПослеОплаты	= константы.ЗакрыватьДокументПослеОплаты.Получить();
	Объект.ПечатаемСтикер	= Константы.ПечататьЧекПристроя.Получить();
	ПлатежныйТерминалБезПодключения = Константы.ПлатежныйТерминалБезПодключения.Получить();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
	//Сканер штрихкода
   СтоСП_Клиент.ПодключитьСканерШК(УникальныйИдентификатор);

   	ПересчитатьСумму();
	РасчитатьЗаголовки() ;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		//Если Объект.Заказы.НайтиСтроки(новый Структура("Отправлено",Ложь)).Количество()>0 Тогда
		//	ОтправитьНаСервере();
		//	Для каждого стр из Объект.Заказы Цикл
		//		Если стр.Отправлено Тогда
		//			ОповеститьОбИзменении(стр.Пристрой);
		//		Конецесли;
		//	КонецЦикла	
		//	
		//КонецЕсли;
		Если Объект.Заказы.НайтиСтроки(новый Структура("Отправлено",Ложь)).Количество()>0 Тогда
			ТекстСообщения = "Не все позиции привязаны к стикерам. Документ не проведен. При отсутствии интернета, можете записать документ и провести его позже."+символы.ПС + 
							 "При возникновении ошибки привязки, проверьте уникальность стикера пристроя.";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Отказ=Истина;
		КонецЕсли;
	КонецЕсли;
	Если не ЗначениеЗаполнено(Объект.ВидОплаты) Тогда
		Объект.ВидОплаты = ПредопределенноеЗначение("Перечисление.ФормыОплаты.Наличные");
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
//	Если Константы.ВыгружатьПриходПриЗаписи.Получить()  
//		или Константы.ВыгружатьТранзитПриЗаписи.Получить()  Тогда
//		ФоновыеЗадания.Выполнить("СтоСПФоновые.Запустить_Выгрузку_100СП",,1,"Запустить_Выгрузку_100СП");
//	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////

&НаСервере
Процедура ГруппаСтраницыПриСменеСтраницыНаСервере()
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаПротокол Тогда
		парамДок=Протокол.Параметры.Элементы.Найти("Документ");
		парамДок.Значение=Объект.Ссылка;
		парамДок.Использование=Истина;
	Конецесли;	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ГруппаСтраницыПриСменеСтраницыНаСервере();
КонецПроцедуры


#КонецОбласти


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
Процедура ВвестиШтрихКодВручную(Команда)
	ОткрытьФорму("ОбщаяФорма.ФормаВводаШК",,ЭтотОбъект,,,,Новый ОписаниеОповещения("ВвестиШтрихКодВручную_Завершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ВвестиШтрихКодВручную_Завершение(ШК, ДополнительныеПараметры) Экспорт
	ОбработатьШКнаКлиенте(ШК);
КонецПроцедуры	


// Конец СтандартныеПодсистемы.ПодключаемыеКоманды



&НаКлиенте
Функция 	ПроверитьЗаполнениеДокумента()
	
	Результат = Истина;
	
	Текст = "";
	Если Объект.Заказы.Количество() = 0 и  Объект.ЗаявкиНаДоставку.Количество() = 0 Тогда
		Текст = Текст + НСтр("ru = 'Не выбрано ни одного Пристроя'");
		Результат = Ложь;
	КонецЕсли;
	Если не ЗначениеЗаполнено(Объект.ВидОплаты) Тогда
		Текст = Текст + НСтр("ru = 'Не выбран вид оплаты'");
		Результат = Ложь;
	КонецЕсли;
	
	Если не Объект.Проведен Тогда
		Текст = Текст + НСтр("ru = 'документ не проведен!'");
		Результат = Ложь;
	КонецЕсли;	
	
	
	Если Текст <> "" Тогда
		ТекстЗаголовка = НСтр("ru = 'Ошибка заполнения'");
		ПоказатьПредупреждение(, Текст, 10 ,ТекстЗаголовка);
	КонецЕсли;
	
	
	
	Возврат Результат;
	
КонецФункции

Процедура УстановитьВидимость()
	ТолькоПросмотр 	= ?(ТолькоПросмотр,
						ТолькоПросмотр,
						( Объект.НомерЧекаККМ<>0) или 
						  (ЗначениеЗаполнено(Объект.ВидОплаты) и Объект.Проведен)
						);
						
	Элементы.ПечатьСтикеров.Видимость = Объект.ПечатаемСтикер;						
						
КонецПроцедуры	

Процедура ПересчитатьСумму()
	Объект.СтоимостьИтого	= 	Объект.Заказы.Итог("Сумма")+Объект.ЗаявкиНаДоставку.Итог("Сумма");									
КонецПроцедуры	


&НаКлиенте
Процедура ЗаказыПриИзменении(Элемент)
	ПересчитатьСумму();
	РасчитатьЗаголовки()
КонецПроцедуры

#Область ОплатитьНаличными
&НаКлиенте
Процедура ОплатитьНаличными(Команда)
	ВидОплаты = ПредопределенноеЗначение("Перечисление.ФормыОплаты.Наличные");
	ПроверитьИОплатить(ВидОплаты);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИОплатить(ВидОплаты)
	Объект.ВидОплаты = ВидОплаты;
	Если не  ПроверитьЗаполнениеДокумента() Тогда Возврат; КонецЕсли;    
	Если Модифицированность и ВидОплаты <> ПредопределенноеЗначение("Перечисление.ФормыОплаты.ПлатежнаяКарта") Тогда 
//		Если не СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(ЭтотОбъект) Тогда
//			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Документ не записан.Оплата не выполнена!");
//			Возврат;
//		КонецЕсли;
	КонецЕсли;	 

	Если Объект.Заказы.НайтиСтроки(новый Структура("Отправлено",Ложь)).Количество()>0 Тогда
		
		Режим 		= РежимДиалогаВопрос.ДаНет;
		Оповещение 	= Новый ОписаниеОповещения("ЗавершениеОплаты", ЭтотОбъект,ВидОплаты);
		ПоказатьВопрос(Оповещение, "Не ко всем позициям пристроя привязан стикер. Продолжить оплату?", Режим, 0);		
	Иначе		
		ЗавершениеОплаты(КодВозвратаДиалога.Да, ВидОплаты);	
	КонецЕсли


КонецПроцедуры




&НаКлиенте
Процедура ЗавершениеОплаты(Результат, ВидОплаты) Экспорт
	
	Если результат = КодВозвратаДиалога.нет Тогда Возврат; КонецЕсли;	
	Если ВидОплаты = ПредопределенноеЗначение("Перечисление.ФормыОплаты.Наличные") Тогда
		ПринятьОплату(ВидОплаты);
	ИначеЕсли ВидОплаты = ПредопределенноеЗначение("Перечисление.ФормыОплаты.ПлатежнаяКарта") Тогда		
		Если ПлатежныйТерминалБезПодключения Тогда
			ПринятьОплату(ВидОплаты);		
		Иначе	
			ОплатитьБезнал(ВидОплаты);
		КонецЕсли;	
	ИначеЕсли ВидОплаты = ПредопределенноеЗначение("Перечисление.ФормыОплаты.ОплатаQR")  Тогда
		ПринятьОплату(ВидОплаты);		
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ПринятьОплату(ВидОпреации)
	
	Объект.ВидОплаты = ВидОпреации;
	Если СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(ЭтотОбъект) Тогда
		ПослеОплаты();
		спПочтовыеСообщения.ОтправитьЧекРасходной(объект.Ссылка);
	КонецЕсли
	;	
	
КонецПроцедуры	


&НаКлиенте
Процедура изменитьОценочнуюСтоимость(Команда)
	Если  Элементы.ЗаявкиНаДоставку.ТекущиеДанные<> Неопределено Тогда
		отбор = Новый структура("Ключ",Элементы.ЗаявкиНаДоставку.ТекущиеДанные.Заявка);
		ОповещениеОЗакрытии = новый ОписаниеОповещения("ОповеститьФорму",ЭтотОбъект,отбор);
		ОткрытьФорму("Справочник.ЗаявкаНаДоставку.Форма.ФормаРедактированияОценочнойСтоимости",отбор,ЭтаФорма,,,,ОповещениеОЗакрытии,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьФорму(Параметры,ДополнительныеПараметры) Экспорт
	ОповеститьОбИзменении(ДополнительныеПараметры.Ключ);
	Прочитать();
КонецПроцедуры	


#КонецОбласти


&НаКлиенте
Процедура РасчитатьЗаголовки()
	
	всегоПристроя = Объект.Заказы.Количество();
	Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаПристрой.Заголовок=?(всегоПристроя=0,"Пристрой","Пристрой ("+всегоПристроя+")");

	всегоЗаявок = Объект.ЗаявкиНаДоставку.Количество();
	Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаЗаявкиНаДоставку.Заголовок=?(всегоЗаявок=0,"Заявки на доставку","Заявки на доставку ("+всегоЗаявок+")");
	

КонецПроцедуры


&НаСервере
Процедура ОбновитьУчастникаНаСервере()
	аспПроцедурыОбменаДанными.ПолучитьУчастниковПоКодам(Объект.Участник);// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьУчастника(Команда)
	ОбновитьУчастникаНаСервере();
	ОповеститьОбИзменении(Объект.Участник);
КонецПроцедуры

&НаКлиенте
Процедура ПечатьСтикеров(Команда)
	командаПечати		= ПолучитьКомандуПечати("Печать cтикеров");
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(ЭтаФорма.Команды[командаПечати], ЭтотОбъект, Объект);
    ПересчитатьСумму();
КонецПроцедуры

Функция  ПолучитьКомандуПечати(ИмяКоманды)
	
	Для каждого ком из ЭтаФорма.Команды Цикл
		Если ком.Заголовок=ИмяКоманды Тогда
			Возврат ком.Имя;
		КонецЕсли;
	КонецЦикла;	
КонецФункции
