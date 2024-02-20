

#Область СоздатьЗаказТК

&НаКлиенте
Процедура ПолучитьНомерОтправления(Команда)    
	если не ПроверитьЗаполнение() Тогда Возврат; КонецЕсли ;	
	
	Записать();
	Если не ЗаполнитьОбъявленнуюСтоимость() Тогда
		Предупреждение("Не заполнена объявленная стоимоть");
	КонецЕсли;	
	Если Объект.Тип="postMail" или Объект.Тип="ems" Тогда
		НорализацияФИОЗавершение = новый ОписаниеОповещения("СформмироватьЗаказНаСервере",ЭтотОбъект);
		ОткрытьФорму("Документ.ОтправлениеТранзита.Форма.НормализацияФИО",новый Структура("ФИО",Объект.ФИО),ЭтаФорма,,,,НорализацияФИОЗавершение,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Возврат;
	КонецЕсли;

	СформмироватьЗаказНаСервере();		
	Попытка
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

Процедура СформмироватьЗаказНаСервере(ПараметрыФИО=Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	Если ЗначениеЗаполнено(Объект.Коробка) и не ЗначениеЗаполнено(Объект.Коробка.МетодОплаты) и Объект.Коробка.ВидСтикера=Перечисления.ВидыСтикеров.ГруппаДоставки тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбран метод оплаты! ");
		Возврат;	
	КонецЕсли;
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ОтправлениеТранзита"));
	Если   (Объект.Тип="postMail" или Объект.Тип="ems") и ПараметрыФИО<>Неопределено Тогда
		об.СформироватьЗаказПочтаРоссии(ПараметрыФИО);   //Перенесено в обработкуОповещения
	Иначе //Если   Объект.Тип="dpd" или Объект.Тип="boxberry" или Объект.Тип="boxberryCourier" Тогда
		
		Если ЗначениеЗаполнено(объект.ИдентификаторЗаказаВТК) Тогда
			ПолучитьИнформациюОЗаказеНаСервере();
		Иначе	
			Интеграция_ТранспортныеКомпании_Общий.СформироватьЗаказ(об);
		КонецЕсли;
		
	КонецЕсли;


	
	ЗначениеВДанныеФормы(об,Объект);
	УстановитьДоступность();
КонецПроцедуры	

&НаКлиенте
Процедура ПоказатьРасчетСтоимости(Команда)
	Элементы.РасчетСтоимости.Видимость = не Элементы.РасчетСтоимости.Видимость;
КонецПроцедуры


&НаКлиенте
Процедура ОписаниеЗаказаПР(Команда)
	ОписаниеЗаказаПРНаСервере();
КонецПроцедуры

Процедура ОписаниеЗаказаПРНаСервере()
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ОтправлениеТранзита"));
	
	об.ОписаниеЗаказаПочтаРоссии(Объект.НомерЗаказа);
	ЗначениеВДанныеФормы(об,Объект);
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьНомер(Команда)
	Объект.НомерЗаказа="";
	Объект.ВнутреннийНомерЗаказаТК="";
	Объект.ИдентификаторЗаказаВТК = "";
	Объект.ИдентификаторКвитанцииВТК = "";
	УстановитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЗаказВТК(Команда)
	Записать();
	УдалитьЗаказВТКНаСервере();
	Попытка
		записан=Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
		Если Записан Тогда
			//Закрыть();
		Иначе
			Сообщить("Документ не записан");
		КонецЕсли
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;

КонецПроцедуры


Процедура УдалитьЗаказВТКНаСервере()
	если не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли ;	
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ОтправлениеТранзита"));
	Если Объект.Тип="sdecCourier" или Объект.Тип="sdec" Тогда
		Интеграция_СДЭК_в20.УдалениеЗаказа(об);
	ИначеЕсли Объект.Тип="boxberry" или Объект.Тип="boxberryCourier" Тогда
		об.УдалитьЗаказBoxBerry();
	ИначеЕсли Объект.Тип="dpd" Тогда
		Интеграция_ТранспортныеКомпании_Общий.УдалитьЗаказ(об);
	КонецЕсли;	
	ЗначениеВДанныеФормы(об,Объект);
	УстановитьДоступность();
КонецПроцедуры

#КонецОбласти

#Область ПолучитьКвитанциюТК

&НаКлиенте
Процедура ПолучитьКвитанцию(Команда)
	
	#Если не ВебКлиент Тогда
	Записать();
	файл= ПолучитьКвитанциюнаСервере();	
	Если файл <> Неопределено Тогда
		Если ТипЗнч(Файл)=Тип("Структура") Тогда
			Если Объект.Тип="sdec" или Объект.Тип = "sdecCourier" или Объект.Тип = "postamat"  Тогда
				ИмяФ=ПолучитьИмяВременногоФайла(файл.ТипФайла);
				ПолучитьФайл(файл.АдресФайла,ИмяФ,Ложь);
				ЗапуститьПриложение(ИмяФ)
			КонецЕсли;
			
			Если Объект.Тип="dpd" и файл.ТипФайла = "Хранилище" Тогда
				ИмяФ=ПолучитьИмяВременногоФайла("pdf");
				ПолучитьФайл(файл.Файл,ИмяФ);
				ЗапуститьПриложение(ИмяФ)
			КонецЕсли;
			
			Если Объект.Тип="postMail" или Объект.Тип="ems" Тогда
				ИмяФ=ПолучитьИмяВременногоФайла("pdf");
				Если файл.Успешно Тогда
					ПолучитьФайл(файл.Адрес,ИмяФ);
				Конецесли;
				
			Иначе
				Если Файл.Свойство("Квитанция") Тогда
					ЗапуститьПриложение(Файл.Квитанция); 
				КонецЕсли;
				Если Файл.Свойство("Акт") Тогда
					ЗапуститьПриложение(Файл.Акт); 
				КонецЕсли;
				
			КонецЕсли;
		Иначе	
			Адрес=файл;
			Описание=Новый ОписаниеПередаваемогоФайла(ПолучитьИмяВременногоФайла("pdf"),Адрес);
			МассивОписаний=Новый Массив;
			МассивОписаний.Добавить(Описание);
//			НачатьПолучениеФайлов(МассивОписаний,,,Ложь );
			ПолучитьФайлы(МассивОписаний,,,Ложь);			
			ЗапуститьПриложение(МассивОписаний[0].Имя);
		КонецЕсли;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось получить квитанцию!");
	КонецЕсли;
	#КонецЕсли	
КонецПроцедуры

Функция ПолучитьКвитанциюнаСервере()
	если не ПроверитьЗаполнение() Тогда
		отказ=истина;
		Возврат неопределено
	КонецЕсли ;	
	Если ЗначениеЗаполнено(Объект.Коробка) и не ЗначениеЗаполнено(Объект.Коробка.МетодОплаты)  и Объект.Коробка.ВидСтикера=Перечисления.ВидыСтикеров.ГруппаДоставки тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбран метод оплаты! ");
		Возврат неопределено;	
	КонецЕсли;
	
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ОтправлениеТранзита"));
	Если   Объект.Тип="dpd" Тогда
		Протокол = Интеграция_ТранспортныеКомпании_Общий.ПолучитьНаклейки(об);
		ЗначениеВДанныеФормы(об,Объект);
		УстановитьДоступность();
		Возврат Протокол;

	КонецЕсли;
	
	Если   Объект.Тип="postMail" или Объект.Тип="ems" Тогда
		
		Возврат Интеграция_ПочтаРоссии.ПолучитьПечатныеФормыДоПартии(Объект.ВнутреннийНомерЗаказаТК,ЭтоEMS);
	ИначеЕсли   Объект.Тип="boxberry" или Объект.Тип="boxberryCourier" Тогда	
		Файл=об.СформироватьКвитанциюBoxBerry();
	Иначе
		Протокол = Интеграция_СДЭК_в20.ФормированиеКвитанцииКЗаказу(об);
		Возврат Протокол;
		//Файл=об.СформироватьКвитанциюСДЭК();
	КонецЕсли;

//	Файл=об.СформироватьКвитанциюСДЭК();
	ЗначениеВДанныеФормы(об,Объект);
	УстановитьДоступность();
	Возврат Файл;
КонецФункции

#КонецОбласти




#Область РасчетСтоимостиДоставки

функция получитьВидРПО(Наименование)
	соотв = новый Соответствие;
	соотв.Вставить("Посылка ""нестандартная""",	Перечисления.ВидРПО.POSTAL_PARCEL);
	соотв.Вставить("Посылка ""онлайн""",			Перечисления.ВидРПО.ONLINE_PARCEL);
	соотв.Вставить("Курьер ""онлайн""",			Перечисления.ВидРПО.ONLINE_COURIER);
	соотв.Вставить("Отправление EMS",			Перечисления.ВидРПО.EMS);
	соотв.Вставить("EMS оптимальное",			Перечисления.ВидРПО.EMS_OPTIMAL);
	соотв.Вставить("Письмо",					Перечисления.ВидРПО.LETTER);
	соотв.Вставить("Бандероль",					Перечисления.ВидРПО.BANDEROL);
	соотв.Вставить("Бизнес курьер",				Перечисления.ВидРПО.BUSINESS_COURIER);
	соотв.Вставить("Бизнес курьер экпресс",		Перечисления.ВидРПО.BUSINESS_COURIER_ES);
	соотв.Вставить("Посылка 1-го класса",		Перечисления.ВидРПО.PARCEL_CLASS_1);
	Возврат соотв.Получить(Наименование);
КонецФункции

&НаКлиенте
Процедура ОбновитьСтоимостьИтого(Команда)
	ПодсчитатьСтоимостьНаСервере();
КонецПроцедуры

Процедура ПодсчитатьСтоимостьНаСервере()
	Если Объект.ТочкаНазначения.Код = "0092" Тогда
		СуммаНадбавки = СтоСПОбмен_ГруппыДоставки.ПолучитьНадбавку(Объект.Коробка);
		Если СуммаНадбавки = 0 или Не значениеЗаполнено(СуммаНадбавки) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось получить сумму надбавки для: "+Объект.коробка);
		КонецЕсли;	
		
		Объект.ТарифПВ = + СуммаНадбавки;
		 Объект.ТарифПВнп =  + СуммаНадбавки+35;

		
	КонецЕсли;	
	
	Если объект.РасчетСтоимостиПоВсемТарифам Тогда 
		МассСтрок = объект.РасчетКалькулятораПочта.найтистроки(Новый Структура("ВыбралУчастник",Истина));
		Если МассСтрок.Количество()>0 Тогда
			Объект.ВидРПО = получитьВидРПО(МассСтрок[0].ВидРПО);
		КонецЕсли;
		Если Объект.Коробка.МетодОплаты = Перечисления.МетодыОплаты.prepay Тогда
			Объект.КатегорияРПО = Перечисления.КатегорияРПО.WITH_DECLARED_VALUE;
		Иначе	
			Объект.КатегорияРПО = Перечисления.КатегорияРПО.WITH_DECLARED_VALUE_AND_CASH_ON_DELIVERY;
		КонецЕсли;
	КонецЕсли;
		
		
	
	
	Если Объект.Коробка.ВидСтикера=Перечисления.ВидыСтикеров.ЗаказТК или не ЗначениеЗаполнено(Объект.Коробка) Тогда
		Если Объект.РасчетСтоимостиПоВсемТарифам Тогда
			МассСтрок = объект.РасчетКалькулятораПочта.найтистроки(Новый Структура("ВыбралУчастник",Истина));
			Если МассСтрок.Количество()=0 Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбран тариф!");
			Иначе
				Объект.ИтогоСтоимость=МассСтрок[0].ТарифТК+Объект.ТарифПВ;		
			КОнецЕсли;	
		Иначе	
			Объект.ИтогоСтоимость=Объект.ТарифТК+Объект.ТарифПВ;	
		КонецЕсли;	
	ИначеЕсли Объект.Коробка.ВидСтикера=Перечисления.ВидыСтикеров.ГруппаДоставки Тогда
		Если Объект.РасчетСтоимостиПоВсемТарифам Тогда
			Если Объект.Коробка.МетодОплаты = Перечисления.МетодыОплаты.cod Тогда //Наложенный платеж
				НайденыСтроки = Объект.РасчетКалькулятораПочта.НайтиСтроки(Новый Структура("ВыбралУчастник",Истина));
				Если НайденыСтроки.Количество() > 0 Тогда
					Объект.ИтогоСтоимость = НайденыСтроки[0].СтоимостьНалПлатеж;
				КонецЕсли;
			Иначе	
				Объект.ИтогоСтоимость				= 0;
			КонецЕсли;
	
				
		Иначе
			
			Если Объект.ТарифТК > 0 Тогда
				базаНалПлатеж				= Объект.ТарифТК + Объект.ТарифПВнп  + Объект.ОбъявленнаяСтоимость * Объект.ПроцентОС / 100;
				базаПредоплата				= Объект.ТарифТК + Объект.ТарифПВ 	 + Объект.ОбъявленнаяСтоимость * Объект.ПроцентОС / 100;
				
				Объект.СтоимостьДоставки			= Окр(базаНалПлатеж + базаНалПлатеж * Объект.Процент / 100, 0);
				Объект.СтоимостьДоставкиПредоплата	= Окр(базаПредоплата, 0);
				
			КонецЕсли;	
	//		
			
			
			
			//Объект.СтоимостьДоставки			= Окр((Объект.ТарифТК + Объект.ТарифПВнп
			//		+ Объект.ОбъявленнаяСтоимость * Объект.ПроцентОС / 100) + (Объект.ТарифТК + Объект.ТарифПВнп
			//		+ Объект.ОбъявленнаяСтоимость * Объект.ПроцентОС / 100) * Объект.Процент / 100, 0);
			//Объект.СтоимостьДоставкиПредоплата	= Окр(Объект.ТарифТК + Объект.ТарифПВ
			//		+ Объект.ОбъявленнаяСтоимость * Объект.ПроцентОС / 100, 0);
			
			Если Объект.Коробка.МетодОплаты = Перечисления.МетодыОплаты.prepay Тогда
				Объект.ИтогоСтоимость				= 0;//(Объект.ТарифТК+Объект.ТарифПВ);
			ИначеЕсли Объект.Коробка.МетодОплаты = Перечисления.МетодыОплаты.cod Тогда
				Объект.ИтогоСтоимость				= Окр((Объект.ТарифТК + Объект.ТарифПВнп
					+ Объект.ОбъявленнаяСтоимость * Объект.ПроцентОС / 100) + (Объект.ТарифТК + Объект.ТарифПВнп
					+ Объект.ОбъявленнаяСтоимость * Объект.ПроцентОС / 100) * Объект.Процент / 100, 0);
			Иначе
				Объект.ИтогоСтоимость=0;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли	
КонецПроцедуры 


&НаКлиенте
Процедура ПолучитьСтоимостьПоТарифу(Команда)
	Если не ПроверитьЗаполнение() тогда
		Возврат;
	Конецесли;	
	Если не ЗаполнитьОбъявленнуюСтоимость() Тогда
		Предупреждение("Не заполнена объявленная стоимоть");
	КонецЕсли;	
	
	ПолучитьСтоимостьПоТарифуСервере();		
	
	ПодсчитатьСтоимостьНаСервере();	
	
	Модифицированность = Истина;

	УстановитьЗапросОплаты();
	ОповеститьОбИзменении(Объект.Коробка);
КонецПроцедуры


Процедура УстановитьЗапросОплаты()
	Если Объект.ТарифТК>0 и Объект.Коробка.СтатусГруппыДоставки = Перечисления.СтатусыГруппыДоставки.waitForOrders Тогда
		ПараметрыЗаписи = Новый Структура("РежимЗаписи, РежимПроведения",
											РежимЗаписиДокумента.Проведение,
											РежимПроведенияДокумента.Оперативный);
		Записать(ПараметрыЗаписи);
		
		СтоСПОбмен_ГруппыДоставки.ПеревестиВСтатусЗапросОплаты(Объект.Коробка);
		//списокКодов = новый СписокЗначений;
		//списокКодов.Добавить(Объект.Коробка);
		//СтоСПОбмен_ГруппыДоставки.Получить_ПоКодам(списокКодов);
		

	КонецЕсли;

	
	
КонецПроцедуры	


Процедура ПолучитьСтоимостьПоТарифуСервере()
	если не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли ;	
	
	об	= ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ОтправлениеТранзита"));
	Интеграция_ТранспортныеКомпании_Общий.РасчитатьСтоимостьОтправления(об);
	ЗначениеВДанныеФормы(об,Объект);
	УстановитьВидимость();
	УстановитьДоступность();
КонецПроцедуры	


#КонецОбласти

#Область ПолучениеАдреса

&НаКлиенте
Процедура ПолучитьАдресДоставки(Команда)
	ПолучитьАдресДоставкиНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПолучитьАдресДоставкиНаСервере()
	док	= ДанныеФормыВЗначение(Объект, Тип("ДокументОбъект.ОтправлениеТранзита"));
	док.ПолучитьАдресДоставки_Api();
	ЗначениеВДанныеФормы(док, Объект);
КонецПроцедуры


////////////////////////////////

Процедура ЗаполнитьАдрес()
	Если Объект.Заказы.Количество()=0 тогда Возврат; КонецЕсли;
	тзДляАдреса=	Объект.Заказы.Выгрузить(,"Покупка");
	
	тзДляАдреса.Колонки.Добавить("Участник",новый ОписаниеТипов("СправочникСсылка.Участники"));
	тзДляАдреса.ЗаполнитьЗначения(Объект.Участник,"Участник");
	тзАдреса=СПЗаказыТК.ПолучитьАдресаНаТЗЗаказов(тзДляАдреса);
	Если тзАдреса.Количество()=0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось получить адрес с сайта!");	
	Иначе	
		ЗаполнитьЗначенияСвойств(Объект,тзАдреса[0]);
	КонецЕсли;
КонецПроцедуры	

Функция ПолучитьТКПоТипуАдреса(тип)
	Если 	  тип="sdecCourier" или тип="sdec" Тогда
		Возврат СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду("0083");
	ИначеЕсли тип="postMail"  Тогда
		Возврат СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду("0020");	
	ИначеЕсли тип="ems" Тогда
		Возврат СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду("0021");
	ИначеЕсли тип="internationalPost" Тогда
		Возврат СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду("0091");	
	Иначе
		Возврат Справочники.ТочкиРаздачи.ТочкаНеОпределена;
	КонецЕсли
КонецФункции

&НаКлиенте
Процедура ВыбратьАдрес(Команда)
	ФРМ=ПолучитьФорму("Обработка.ОбъединеннаяДоставкаГрузов.Форма.ФормаВыбораАдреса",новый Структура("ВыбранныеСтроки,Источник,Участник",Объект.Заказы,"ОтправлениеГД",Объект.Участник),ЭтаФорма);
	Если ФРМ.Адреса.Количество()=0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось получить адрес с сайта!");
	ИначеЕсли ФРМ.Адреса.Количество()=1 Тогда
		ЗаполнитьЗначенияСвойств(Объект,ФРМ.Адреса[0]);
	Иначе
		ФРМ.открытьМодально();
	Конецесли;
	УстановитьВидимость();
	УстановитьДоступность();
КонецПроцедуры

#КонецОбласти


&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
	
	
	
	Документы.ОтправлениеТранзита.ЗаполнитьОстатками(Объект, Параметры);

	//
	Если Объект.Ссылка.Пустая() и ЗначениеЗаполнено(Объект.ТочкаНазначения) Тогда
		ЗаполнитьЗначенияСвойств(Объект,Объект.ТочкаНазначения,"МестоХранения, Габарит");	
		ЗаполнитьЗначенияСвойств(Объект,Объект.ТочкаНазначения,"ТарифПВ, ТарифПВнп,Процент,ПроцентОС");	
		Объект.ТочкаОтправитель=Константы.СвояТочка.Получить();
	КонецЕсли;
	
	//Для почты россии разные параметры Для разных Методов оплаты
	Если ЗначениеЗаполнено(Объект.Коробка) и Объект.Коробка.МетодОплаты=Перечисления.МетодыОплаты.prepay Тогда
		Объект.КатегорияРПО=Перечисления.КатегорияРПО.WITH_DECLARED_VALUE;
	ИначеЕсли  Объект.Коробка.МетодОплаты=Перечисления.МетодыОплаты.cod Тогда
		Объект.КатегорияРПО=Перечисления.КатегорияРПО.WITH_DECLARED_VALUE_AND_CASH_ON_DELIVERY;
	КонецЕсли;
	
	Если Объект.ТочкаНазначения.Код = "0048" Тогда  //dpd
		Объект.УслугаDPD = Справочники.УслугиDPD.PCL;
		
	КонецЕсли;
	объект.ТарифПВ   = Объект.ТочкаНазначения.ТарифПВ;
	объект.ТарифПВнп = Объект.ТочкаНазначения.ТарифПВнп;
	объект.Процент 	 = Объект.ТочкаНазначения.Процент;
	объект.ПроцентОС = Объект.ТочкаНазначения.ПроцентОС;
	Если не ЗначениеЗаполнено(Объект.Габарит) Тогда
		Объект.Габарит = Объект.ТочкаНазначения.Габарит;
	КонецЕсли;	
	
	Если не ЗначениеЗаполнено(Объект.МестоХранения) Тогда
		Объект.МестоХранения = Объект.ТочкаНазначения.МестоХранения;
	КонецЕсли;	

	/////////////Весы
	РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	Отбор = Новый Структура("РабочееМесто", РабочееМесто);
	ОборудованиеРМ = Справочники.ПодключаемоеОборудование.Выбрать(,, Отбор);
    Пока ОборудованиеРМ.Следующий() Цикл
		Если НЕ ОборудованиеРМ.УстройствоИспользуется Или ОборудованиеРМ.ПометкаУдаления Тогда
			Продолжить;
		КонецЕсли;
		_ТипОборудования = ОборудованиеРМ.ТипОборудования;
		Если _ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ЭлектронныеВесы Тогда
			Весы = ОборудованиеРМ.Ссылка;		
		КонецЕсли;	
	КонецЦикла;	
	
	
	//////////////////

	мЭтоКурьер  = (Объект.ТочкаНазначения = СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду("0100"));
	ЭтоEMS 		= (Объект.ТочкаНазначения = СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду("0021"));
	
КонецПроцедуры


Функция ПроеритьКорректностьВыбранногоТарифа()
	текстпредупреждения = "";
	Если Объект.РасчетСтоимостиПоВсемТарифам и ЗначениеЗаполнено(Объект.Коробка.МетодОплаты) Тогда 
		помеченныеСтроки = Объект.РасчетКалькулятораПочта.НайтиСтроки(Новый Структура("ВыбралУчастник",Истина));
		Если помеченныеСтроки.Количество() = 0 Тогда
			массСтрок = Объект.РасчетКалькулятораПочта.НайтиСтроки(Новый Структура("ВидРПО",Объект.Коробка.ВидРПОВыбралУчастник));			
			Если МассСтрок.Количество()>0 Тогда
				МассСтрок[0].ВыбралУчастник = Истина;
			Иначе
				текстпредупреждения = "Не найден Тариф!" + символы.ПС+
									  "Участник выбрал : "    + Объект.Коробка.ВидРПОВыбралУчастник + символы.ПС+
									  " 		стоимость: "	 + 	?(Объект.Коробка.МетодОплаты = Перечисления.МетодыОплаты.prepay, Объект.Коробка.СтоимостьДоставкиПредоплата,Объект.Коробка.СтоимостьДоставки) ;
			КонецЕсли
		ИначеЕсли	помеченныеСтроки[0].ВидРПО <> Объект.Коробка.ВидРПОВыбралУчастник Тогда
			текстпредупреждения =  "Отмечен ДРУГОЙ Тариф!" + символы.ПС+
							 "Участник выбрал : "    + Объект.Коробка.ВидРПОВыбралУчастник + символы.ПС+
							 " 		стоимость: "	 + 	?(Объект.Коробка.МетодОплаты = Перечисления.МетодыОплаты.prepay, Объект.Коробка.СтоимостьДоставкиПредоплата,Объект.Коробка.СтоимостьДоставки) + символы.ПС+
							 "В документе отмечен: " + помеченныеСтроки[0].ВидРПО + символы.ПС+
			                 " 		стоимость: "	 + 	?(Объект.Коробка.МетодОплаты = Перечисления.МетодыОплаты.prepay, помеченныеСтроки[0].СтоимостьПредоплата,помеченныеСтроки[0].СтоимостьНалПлатеж);
//			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,Объект.Ссылка);

		КонецЕсли;	
	КонецЕсли;
	ПодсчитатьСтоимостьНаСервере();
	Возврат текстпредупреждения;
КонецФункции

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ПровелиОтправлениеТранзита",истина);
	Если ЗначениеЗаполнено(Объект.Коробка) Тогда
		ОповеститьОбИзменении(Объект.Коробка);
	КонецЕсли;	
	УстановитьДоступность();
КонецПроцедуры



&НаКлиенте
Процедура ПриОткрытии(Отказ)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Объект.Адрес = "" Тогда
		ПолучитьАдресДоставкиНаСервере();
		//ВыбратьАдрес(Истина);
	КонецЕсли;
	текстпредупреждения = ПроеритьКорректностьВыбранногоТарифа();
	Если текстпредупреждения <> "" Тогда
		ПоказатьПредупреждение(,текстпредупреждения);
	КонецЕсли;	

	УстановитьВидимость();
	УстановитьДоступность();   
	//Сканер штрихкода
   СтоСП_Клиент.ПодключитьСканерШК(УникальныйИдентификатор);
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ИсточникВыбора.ИмяФормы = "Документ.ОтправлениеТранзита.Форма.НормализацияФИО" Тогда
		СформмироватьЗаказНаСервере(ВыбранноеЗначение);		
		Попытка
			записан=Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
			Если Записан Тогда
				//Закрыть();
			Иначе
				Сообщить("Документ не записан");
			КонецЕсли
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
	ИначеЕсли ИсточникВыбора.ИмяФормы ="Обработка.ОбъединеннаяДоставкаГрузов.Форма.ФормаВыбораАдреса" Тогда
		ЗаполнитьЗначенияСвойств(Объект,ВыбранноеЗначение);
	Иначе	
		Если ВыбранноеЗначение.Свойство("code") Тогда
			УстановитьКодПВЗнаСервере(Новый Структура ("Code",ВыбранноеЗначение.Code));
		Иначе	
			УстановитьКодПВЗнаСервере(ВыбранноеЗначение);
		КонецЕсли;	
	КонецЕсли;	
	УстановитьВидимость();
	УстановитьДоступность();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Объект.Коробка.ВидСтикера=Перечисления.ВидыСтикеров.ГруппаДоставки Тогда
		Если Объект.РасчетСтоимостиПоВсемТарифам тогда возврат КонецЕсли;
		Если (Объект.СтоимостьДоставки=0 или Объект.СтоимостьДоставкиПредоплата=0) и не мЭтоКурьер Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("""Стоимость Доставки"" и ""Стоимость Доставки предоплата"" должны быть указанны! ",,,,Отказ);
		КонецЕсли;	
	КонецЕсли;		

КонецПроцедуры




#Область СобытияФормы

&НаКлиенте
Процедура НомерЗаказаПриИзменении(Элемент)
	УстановитьДоступность();
КонецПроцедуры


Процедура УстановитьКодПВЗнаСервере(ВыбранноеЗначение)
	Если Объект.тип="boxberry" Тогда
		Объект.КодПВЗ=ВыбранноеЗначение.Код;
	Иначе	
		Объект.КодПВЗ=ВыбранноеЗначение.Code;
		//Если ВыбранноеЗначение.Type="PVZ" Тогда
		//	Объект.Тип="sdec";
		//иначе
		//	Объект.Тип="postamat"
		//КонецЕсли;			
	КонецЕсли;	
КонецПроцедуры


#КонецОбласти

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
    УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать



Функция ЗаполнитьОбъявленнуюСтоимость()
	Для каждого стр из Объект.Заказы Цикл
		масСтрок=Объект.Коробка.Состав.НайтиСтроки(новый Структура("Покупка, Участник",стр.Покупка,Объект.Участник));
		Если масСтрок.Количество()> 0 Тогда
			стр.ОбъявленнаяСтоимость=масСтрок[0].Цена;
		КонецЕсли;
	КонецЦикла ;
	Если Объект.ОбъявленнаяСтоимость<=0 Тогда 
		Объект.ОбъявленнаяСтоимость=Объект.Заказы.Итог("ОбъявленнаяСтоимость");
	КонецЕсли;	
	
	Возврат (Объект.ОбъявленнаяСтоимость>0);
	
КонецФункции


Процедура УстановитьДоступность()

	Элементы.ГруппаЗаказ.ТолькоПросмотр				= не (объект.НомерЗаказа="") и не мЭтоКурьер;	
	Элементы.ГруппаНомерОтправления.ТолькоПросмотр	= не (объект.НомерЗаказа="") и не мЭтоКурьер;
	Элементы.ПолучитьНомерОтправления.Доступность   =  (объект.НомерЗаказа="");
	УстановитьВидимость()
КонецПроцедуры	


Процедура УстановитьВидимость()
	ЭтоПочта	= (Объект.Тип="postMail" 	или Объект.Тип="ems");
	ЭтоСДЭК 	= (Объект.Тип="sdecCourier" или Объект.Тип="sdec" или Объект.Тип = "postamat");
	ЭтоБоксбери = (Объект.Тип="boxberry" 	или Объект.Тип="boxberryCourier");
	ЭтоDPD 		= (Объект.Тип="dpd");
	
	Элементы.ГруппаПочтаРоссии.Видимость	= Ложь;
	Элементы.ГруппаБоксберри.Видимость		= Ложь;
	Элементы.ГруппаСДЭК.Видимость			= Ложь;
	Элементы.ГруппаDPD.Видимость			= Ложь;
	
	Если ЭтоБоксбери Тогда Элементы.ГруппаПараметрыТК.ТекущаяСтраница = Элементы.ГруппаБоксберри КонецЕсли;
	
	Элементы.ГруппаПочтаРоссии.Видимость	= ЭтоПочта;
	Элементы.ГруппаБоксберри.Видимость		= ЭтоБоксбери;
	Элементы.ГруппаСДЭК.Видимость			= ЭтоСДЭК;
	Элементы.ГруппаDPD.Видимость			= ЭтоDPD;
	
	Элементы.ГруппаРасчетКалькулятора.ТекущаяСтраница=Элементы.РКСтрокой;
	
	Если не ЗначениеЗаполнено(Объект.Тариф) Тогда
		Если 	  Объект.Тип = "sdec" Тогда
			Объект.Тариф=Справочники.ТарифыТК.НайтиПоКоду("136");
		ИначеЕсли Объект.Тип = "postamat" Тогда
			Объект.Тариф=Справочники.ТарифыТК.НайтиПоКоду("302");
		ИначеЕсли Объект.Тип = "sdecCourier" Тогда
			Объект.Тариф=Справочники.ТарифыТК.НайтиПоКоду("137");
		КонецЕсли	
	КонецЕсли;	
	
	
	Элементы.КатегорияРПО.Видимость  = ложь;
	Элементы.ВидРПО.Видимость		 = ложь;
	
	//Если Не ЗначениеЗаполнено(Объект.ВидРПО) Тогда
	//	Если 		Объект.ТочкаНазначения = СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду("0020") Тогда
	//		Объект.ВидРПО=Перечисления.ВидРПО.POSTAL_PARCEL;
	//	ИначеЕсли 	Объект.ТочкаНазначения = СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду("0021") Тогда	
	//		Объект.ВидРПО=Перечисления.ВидРПО.PARCEL_CLASS_1;
	//    КонецЕсли;
	//КонецЕсли;
	//Если Не ЗначениеЗаполнено(Объект.КатегорияРПО) Тогда
	//	Объект.КатегорияРПО = Перечисления.КатегорияРПО.WITH_DECLARED_VALUE_AND_CASH_ON_DELIVERY;
	//КонецЕсли;	
	
	
	Если не ЗначениеЗаполнено(Объект.ГородОтправитель) Тогда
		Объект.ГородОтправитель = Объект.ТочкаНазначения.ГородОтправления;
	КонецЕсли;	
	
	Если  не ЗначениеЗаполнено(Объект.СДЭКкодПВЗсдачи) Тогда
		Объект.СДЭКкодПВЗсдачи = Объект.ТочкаНазначения.ТК.КодПунктаСдачи;
	КонецЕсли;	

	
	Если не ЗначениеЗаполнено(Объект.ПунктПриема) Тогда
		Если Объект.Тип="boxberry" или Объект.Тип="boxberryCourier" Тогда
			Объект.ПунктПриема=Константы.ПунктПриемаBoxBerryПоУмолчанию.Получить();
		КонецЕсли;
	КонецЕсли;	
	Если не ЗначениеЗаполнено(Объект.ИндексОтправителя) и (Объект.Тип="postMail" или Объект.Тип="ems")   Тогда
		ТК							= ПолучитьТКПоТипуАдреса(Объект.Тип);
		Объект.ИндексОтправителя	= Константы.ИндексОтправителяПРУмолчание.Получить();
	КонецЕсли;
	Если Объект.РасчетСтоимостиПоВсемТарифам Тогда
		Элементы.ГруппаРасчетКалькулятора.ТекущаяСтраница=Элементы.ГруппаРасчетКалькулятора.ПодчиненныеЭлементы.РКТаблицей;
	Иначе
		Элементы.ГруппаРасчетКалькулятора.ТекущаяСтраница=Элементы.ГруппаРасчетКалькулятора.ПодчиненныеЭлементы.РКСтрокой;
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура СменитьПунктВыдачи(Команда)
	Если Объект.Тип="dpd" Тогда
		ОткрытьФорму("Справочник.ТранспортныеКомпании.Форма.ВыборПунктаВыдачиDPD",новый структура("ГородНазначения",Объект.Город),ЭтаФорма,,,,новый ОписаниеОповещения("Обработчик_ВыборПунктаСдачиDPD",ЭтотОбъект),РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);		
		возврат;
	КонецЕсли;	
	Если Объект.Тип="boxberry" Тогда
		фрм=ПолучитьФорму("Справочник.ПунктыВыдачиBoxBerry.ФормаВыбора",новый структура("КодГородаНазначения",Объект.cityCode),ЭтаФорма);
	Иначе	
		фрм=ПолучитьФорму("Документ.ОтправлениеТранзита.Форма.ВыборПунктаВыдачиСДЭК",новый структура("КодГородаНазначения",Объект.cityCode),ЭтаФорма);
	КонецЕсли;
	фрм.открыть();
КонецПроцедуры


Процедура Обработчик_ВыборПунктаСдачиDPD(РезультатЗакрытия, параметр)
	Если ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		Объект.КодПВЗ	= РезультатЗакрытия.КодПВ;
		Объект.cityCode	= РезультатЗакрытия.КодГорода;
	КонецЕсли;
КонецПроцедуры	


&НаКлиенте
Процедура ГородОтправительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если Объект.Тип="boxberry" или Объект.Тип="boxberryCourier" Тогда
		ТипСтр = "СправочникСсылка.ГородаBoxBerry";
	Иначе	
		ТипСтр = "СправочникСсылка.ГородаСДЭК";
	КонецЕсли;
	
    Элемент.ОграничениеТипа = Новый ОписаниеТипов(ТипСтр);
    Значение = Объект.ГородОтправитель;
    Объект.ГородОтправитель = Элемент.ОграничениеТипа.ПривестиЗначение(Значение);
    Элемент.ВыбиратьТип = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ТарифПВнпПриИзменении(Элемент)
	ПодсчитатьСтоимостьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбновитьГруппуССайтаНаСервере()
	списокКодов = новый СписокЗначений;
	списокКодов.Добавить(число(СтрЗаменить(Объект.Коробка.Код,"гд_","")));
	СтоСПОбмен_ГруппыДоставки.Получить_ПоКодам(списокКодов);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьГруппуССайта(Команда)
	ОбновитьГруппуССайтаНаСервере();
КонецПроцедуры



&НаКлиенте
Процедура ПолучитьСтатусыЗаказа(Команда)
	//ПолучитьСтатусыЗаказаНаСервере();
	данныеОтчета = СП_Отчеты.СтатусыГруппы(Объект.Коробка,ДокументРезультат, УникальныйИдентификатор);
	АдресХранилищаСКД = данныеОтчета.АдресХранилищаСКД;
	АдресРасшифровки  = данныеОтчета.АдресРасшифровки;
КонецПроцедуры



&НаКлиенте
Процедура ПолучитьИсториюЗаказа(Команда)
//	ПолучитьИсториюЗаказаНаСервере();
	данныеОтчета = СП_Отчеты.СтатусЗаказовГруппы(Объект.Коробка,ДокументРезультат,УникальныйИдентификатор);
	АдресХранилищаСКД = данныеОтчета.АдресХранилищаСКД;
	АдресРасшифровки  = данныеОтчета.АдресРасшифровки;

КонецПроцедуры


&НаКлиенте
Процедура ДокументРезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	СтандартнаяОбработка 		= Ложь;
	ПараметрВыполненогоДействия	=  Неопределено;	
	ИсточникДоступныхНастроек 	= Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресХранилищаСКД);
	ОбработкаРасшифровки 		= Новый ОбработкаРасшифровкиКомпоновкиДанных(АдресРасшифровки, ИсточникДоступныхНастроек);
	
	
		
	выпДействие		= ДействиеОбработкиРасшифровкиКомпоновкиДанных.Нет;	
		
	ДоступныеДействия = Новый Массив();
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Отфильтровать);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Оформить);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Расшифровать);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Сгруппировать);
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Упорядочить);
	
	ДополнительныеПункты	= новый СписокЗначений();
	
	
	Оповещение = Новый ОписаниеОповещения("РезультатОбработкаРасшифровки_Продолжение", ЭтаФорма, Расшифровка,
											"РезультатОбработкаРасшифровки_Ошибка",ЭтаФорма);
	ОбработкаРасшифровки.ПоказатьВыборДействия(Оповещение, Расшифровка, ДоступныеДействия, , Истина);
	
	//ОбработкаРасшифровки.ВыбратьДействие(Расшифровка, выпДействие ,ПараметрВыполненогоДействия,ДоступныеДействия,ДополнительныеПункты);
	//
	//Если выпДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.Нет Тогда
	//	
	//ИначеЕсли выпДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда	
	//	ОткрытьЗначение(ПараметрВыполненогоДействия);
	//КонецЕсли;	
		
КонецПроцедуры


&НаКлиенте
Процедура РезультатОбработкаРасшифровки_Продолжение(ВыполненноеДействие, ПараметрВыполненногоДействия, ДополнительныеПараметры) Экспорт
    Если ПараметрВыполненногоДействия <> Неопределено Тогда
        
		Если ВыполненноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда
			//ОткрытьЗначение(ПараметрВыполненногоДействия);
            ПоказатьЗначение(,ПараметрВыполненногоДействия);
        КонецЕсли;
        
    КонецЕсли;        
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки_Ошибка(ВыполненноеДействие, ПараметрВыполненногоДействия, ДополнительныеПараметры) Экспорт
	
	                                 
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

&НаСервере
Процедура ПоказатьИсториюОбменовГруппыНаСервере()
	ДокументРезультат.Очистить();
	структураОтчета 	= СП_Отчеты.ТаблицаГруппыДоставкиИстроияОбменов(Объект.Коробка,УникальныйИдентификатор);
	ДокументРезультат 	= структураОтчета.Результат;
	АдресХранилищаСКД 	= структураОтчета.СКД;
	АдресРасшифровки 	= структураОтчета.ДанныеРасшифровки;
	//ПолучитьИзВременногоХранилища(АдресРасшифровки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьИсториюОбменовГруппы(Команда)
	ПоказатьИсториюОбменовГруппыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)
	ОткрытьФорму("ОбщаяФорма.ФормаОжиданиеВводаШтрихкода",,ЭтотОбъект,,,,Новый ОписаниеОповещения("ВвестиШтрихКодАдминистратора_Завершение", ЭтотОбъект),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры


&НаКлиенте
Процедура ВвестиШтрихКодАдминистратора_Завершение(ШК, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(ШК) =  Тип("Структура") и
		 ШК.Свойство("Администратор")	и
		 ШК.Администратор         			Тогда
		ТолькоПросмотр 									= Ложь;
		Элементы.ЗаказыМестоХранения.ТолькоПросмотр 	= Ложь;
		Элементы.ЗаказыГабарит.ТолькоПросмотр 			= Ложь;
		Элементы.ЗаказыПартия.ТолькоПросмотр 			= Ложь;
		Элементы.ЗаказыТочка.ТолькоПросмотр 			= Ложь;
		Элементы.ЗаказыКоличество.ТолькоПросмотр 		= Ложь;
		Элементы.ГруппаЗаказ.ТолькоПросмотр				= Ложь;	
		Элементы.ГруппаНомерОтправления.ТолькоПросмотр	= Ложь;
		Элементы.ПолучитьНомерОтправления.Доступность   = Ложь;
		Элементы.ТочкаНазначения.ТолькоПросмотр			= Ложь;
	 КонецЕсли;	 
КонецПроцедуры	


&НаКлиенте
Процедура ПолучитьИнформациюОЗаказе(Команда)
	Если ЗначениеЗаполнено(объект.ИдентификаторЗаказаВТК) Тогда
	//	ответ = Интеграция_СДЭК_в20.ИнформацияОЗаказеПоНомеруЗаказа(новый структура("НомерЗаказа",Объект.НомерЗаказа));
	//	протокол = Объект.ПротоколыПередач.Добавить();

		 ПолучитьИнформациюОЗаказеНаСервере();
		//ЗаполнитьЗначенияСвойств(протокол, ответ);
		//Если  ответ.Свойство("ТрекНомер") Тогда
		//	Объект.НомерЗаказа 	= ответ.ТрекНомер;
		//КонецЕсли;	
	КонецЕсли;	
	
	
КонецПроцедуры

Процедура ПолучитьИнформациюОЗаказеНаСервере()
	об = РеквизитФормыВЗначение("Объект");
	ответ 				= Интеграция_СДЭК_в20.ИнформацияОЗаказе(об);
	ЗначениеВДанныеФормы(об, Объект);
КонецПроцедуры	
	


&НаКлиенте
Процедура РасчетКалькулятораПочтаВыбралУчастникПриИзменении(Элемент)
	ТекущийВидРПО = Элементы.РасчетКалькулятораПочта.ТекущиеДанные.ВидРПО;
	выделенныеСтроки = Объект.РасчетКалькулятораПочта.НайтиСтроки(Новый Структура("ВыбралУчастник", истина));
	Для каждого элем из выделенныеСтроки Цикл
		Если элем.ВидРПО <> ТекущийВидРПО Тогда 
			элем.ВыбралУчастник = Ложь;
		КонецЕсли;	
	КонецЦикла;	
	текстпредупреждения = ПроеритьКорректностьВыбранногоТарифа();
	Если текстпредупреждения <> "" Тогда
		ПоказатьПредупреждение(,текстпредупреждения);
	КонецЕсли;	
КонецПроцедуры



&НаКлиенте
Процедура ВыбратьПунктВыдачиСДЭК(Команда)
	ОткрытьФорму("Справочник.ТранспортныеКомпании.Форма.ВыборПунктаВыдачиСДЭК",,ЭтаФорма,,,,новый ОписаниеОповещения("Обработчик_ВыборПунктаСдачиСДЭК",ЭтотОбъект),РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
КонецПроцедуры

Процедура Обработчик_ВыборПунктаСдачиСДЭК(РезультатЗакрытия, параметр)
	Если ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		Объект.СДЭКкодПВЗсдачи 		= РезультатЗакрытия.code;
	КонецЕсли;
	//Объект.КодГородаОтправителя = РезультатЗакрытия.City_Code;
КонецПроцедуры	

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// ПодключаемоеОборудование 
	Если ИмяСобытия = "ScanData" Тогда
		Если Источник = "ПодключаемоеОборудование"   и ВводДоступен() Тогда
			ШК = СтоСП_Клиент.ПолучитьШКизПараметров(Параметр);
			ОбработатьШКнаКлиенте(ШК);
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование

КонецПроцедуры


&НаКлиенте
Процедура 	ОбработатьШКнаКлиенте(ШК)
	
	ДанныеШК    	= СП_Штрихкоды.ПолучитьДанныеПоШК(ШК);
	Если ДанныеШК 	= Неопределено Тогда Возврат КонецЕсли;
	Если Строка(ДанныеШК.Тип) = "Длина" Тогда
		Объект.Длина = ДанныеШК.длина;
	ИначеЕсли Строка(ДанныеШК.Тип) = "Ширина" Тогда
		Объект.Ширина = ДанныеШК.Ширина;
	ИначеЕсли Строка(ДанныеШК.Тип) = "Высота" Тогда
		Объект.Высота = ДанныеШК.Высота; 
	ИначеЕсли Строка(ДанныеШК.Тип) = "Действие по ШК (66)"  и ДанныеШК.Действие = "ПолучитьВес"  Тогда			
		ПолучитьВес(Неопределено);
	КонецЕсли;	
	Модифицированность=Истина;
КонецПроцедуры	

&НаКлиенте
Процедура ПолучитьВес(Команда)
    ЭтаФорма.Доступность = Ложь; //При необходимости можно заблокировать интерфейс пользователя.
     
    ОтображатьСообщения = Ложь;// Не отображать сообщения об ошибке. Сообщения на экран выводиться в процедуре обработки оповещения.
    ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПолучитьВесЗавершение", ЭтотОбъект);
    МенеджерОборудованияКлиент.НачатьПолученияВесаСЭлектронныхВесов(ОповещениеПриЗавершении, УникальныйИдентификатор, Весы, ОтображатьСообщения);

КонецПроцедуры     


&НаКлиенте
Процедура ПолучитьВесЗавершение(РезультатВыполнения, Параметры) Экспорт
 
   ЭтаФорма.Доступность = Истина;// При необходимости разблокируем интерфейс пользователя.

   Если РезультатВыполнения.Результат Тогда
      Объект.Вес = РезультатВыполнения.Вес * 1000;// Вес получен
   Иначе 
      ТекстСообщения = НСтр("ru = 'При выполнении операции произошла ошибка:""%ОписаниеОшибки%"".'");
      ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", РезультатВыполнения.ОписаниеОшибки);
      Сообщить(ТекстСообщения);
   КонецЕсли;

КонецПроцедуры




// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
 
