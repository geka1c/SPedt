#Область ШтрихКоды

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ScanData" Тогда
		Если Источник = "ПодключаемоеОборудование"   и ВводДоступен() Тогда
			ШК = СтоСП_Клиент.ПолучитьШКизПараметров(Параметр);
			ОбработатьШКнаКлиенте(ШК);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура 	ОбработатьШКнаКлиенте(ШК)
	ДанныеШК    = СП_Штрихкоды.ПолучитьДанныеПоШК(ШК);
	Если ДанныеШК = Неопределено Тогда Возврат; КонецЕсли;
	Если Строка(ДанныеШК.Тип) 	= "Номенклатура (61)" Тогда //Номенклатура
		Если ДобавитьТовар(ДанныеШК.Номенклатура) Тогда
			#Если не вебклиент Тогда
				Сигнал();
			#КонецЕсли
		КонецЕсли;		
	ИначеЕсли Строка(ДанныеШК.Тип) 	= "Карта участника (22)"		Тогда	
		Если ЗначениеЗаполнено(ДанныеШК.Владелец) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Карта: "+ДанныеШК.КартаУчастника+" уже привязана к участнику: "+ДанныеШК.Владелец);					
			возврат
		КонецЕсли;	
		Если ДобавитьТовар(ДанныеШК.КартаУчастника) Тогда
			#Если не вебклиент Тогда
				Сигнал();
			#КонецЕсли
		КонецЕсли;		
	Иначеесли Строка(ДанныеШК.Тип) = "Сотрудник (55)" 			Тогда	
		Если СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(этотОбъект,,ДанныеШК.Сотрудник) Тогда
			Закрыть();
		КонецЕсли;		
	КонецЕсли;

	
КонецПроцедуры





&НаКлиенте
Процедура ВвестиШтрихКодВручную(Команда)
	ОткрытьФорму("ОбщаяФорма.ФормаВводаШК",,ЭтотОбъект,,,,Новый ОписаниеОповещения("ВвестиШтрихКодВручную_Завершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ВвестиШтрихКодВручную_Завершение(ШК, ДополнительныеПараметры) Экспорт
	ОбработатьШКнаКлиенте(ШК);
КонецПроцедуры


#КонецОбласти




#Область ОбработчикиСобытий
&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	стр			= Элементы.Товары.ТекущиеДанные;
	стр.Сумма	=стр.Количество*Стр.Цена;
	ПересчитатьСумму();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	стр			= Элементы.Товары.ТекущиеДанные;
	стр.Сумма	=стр.Количество*Стр.Цена;
	ПересчитатьСумму();
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
Процедура 	ФискализацияЧека(Печатать = Ложь) Экспорт
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

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	РасчетСтоимости = РасчетСтоимостиНоменклатуры(Элементы.Товары.ТекущиеДанные.Номенклатура);
	ЗаполнитьЗначенияСвойств(Элементы.Товары.ТекущиеДанные, РасчетСтоимости);
КонецПроцедуры

Функция РасчетСтоимостиНоменклатуры(Номенклатура)
	Если ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура") Тогда
		Цена	= Номенклатура.Цена;
	Иначе
		Цена	= Константы.СтоимостьКартыУчастника.Получить();	
	КонецЕсли;
	РасчетСтоимости = Новый Структура();
	РасчетСтоимости.Вставить("Цена", 		Цена);
	РасчетСтоимости.Вставить("Количество", 	1);
	РасчетСтоимости.Вставить("Сумма", 		Цена);
	
	Возврат РасчетСтоимости;
КонецФункции	

#КонецОбласти 

#Область Вспомогательные

Процедура УстановитьВидимость()
	ТолькоПросмотр 	= ?(ТолькоПросмотр,
						ТолькоПросмотр,
						( Объект.НомерЧекаККМ<>0) или 
						  (ЗначениеЗаполнено(Объект.ВидОплаты) и Объект.Проведен)
						);
КонецПроцедуры	

&НаКлиенте
Функция 	ПроверитьЗаполнениеДокумента()
	
	Результат = Истина;
	
	Текст = "";
	Если Объект.Товары.Количество() = 0 Тогда
		Текст = Текст + НСтр("ru = 'Не выбрано ни одного товара'");
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

Процедура ПересчитатьСумму()
	Объект.СтоимостьИтого	= 	Объект.Товары.Итог("Сумма");									
КонецПроцедуры	

Функция 	ДобавитьТовар(Номенклатура)
	НеКарта = ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура");
	Если НеКарта Тогда
		Цена = Номенклатура.Цена;
	Иначе
		Цена = Константы.СтоимостьКартыУчастника.Получить();
	КонецЕсли;	
	
	строки_Товара = Объект.Товары.НайтиСтроки(Новый Структура("Номенклатура", Номенклатура));
	Если строки_Товара.Количество() = 0 Тогда
		текущийТовар 				= Объект.Товары.Добавить();
		текущийТовар.Номенклатура 	= Номенклатура;
		текущийТовар.Количество		= 1;
		текущийТовар.Цена			= Цена;
		текущийТовар.Сумма			= Цена*текущийТовар.Количество;
		 				
	ИначеЕсли НеКарта Тогда
		текущийТовар				= строки_Товара[0];
		текущийТовар.Количество 	= текущийТовар.Количество + 1;
		текущийТовар.Сумма			= Цена*текущийТовар.Количество;
	КонецЕсли;
	ПересчитатьСумму();
	Возврат истина;
КонецФункции
#КонецОбласти	




#Область Эквайринг
&НаКлиенте
Процедура ОплатитьКартой(Команда)
	Если не  ПроверитьЗаполнение() Тогда Возврат; КонецЕсли;

	Сумма 				= Объект.СтоимостьИтого;
	Объект.ВидОплаты 	= ПредопределенноеЗначение("Перечисление.ФормыОплаты.ПлатежнаяКарта");
	ОчиститьСообщения();

	Если Объект.ОплатаВыполнена Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Для данного документа уже выполнена оплата платежной картой.'"));
		Возврат;
	КонецЕсли;

		ПараметрыОперации					=	МенеджерОборудованияКлиент.ПараметрыВыполненияЭквайринговойОперации();
		ПараметрыОперации.ТипТранзакции		=	"AuthorizeSales";
		ПараметрыОперации.СуммаОперации 	= 	Сумма;
		ПараметрыОперации.НомерЧека			=	"";
		ПараметрыОперации.СсылочныйНомер 	= 	"";

	МенеджерОборудованияКлиент.ПредложитьВыбратьУстройство(
		Новый ОписаниеОповещения("ОплатитьКартойПредложитьВыбратьЭквайринговыйТерминалЗавершение", ЭтотОбъект, ПараметрыОперации),
		"ЭквайринговыйТерминал",
		НСтр("ru='Выберите эквайринговый терминал'"),
		НСтр("ru='Эквайринговый терминал не подключен'"));
КонецПроцедуры  
	
&НаКлиенте
Процедура ПринятьОплату(ВидОпреации)

		Объект.ВидОплаты = ВидОпреации;
		ПараметрыЗаписи = Новый Структура("РежимЗаписи, РежимПроведения, НеПроверятьОтветственного",
		РежимЗаписиДокумента.Проведение,
		РежимПроведенияДокумента.Оперативный,
		Истина);
		Если СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(ЭтотОбъект) Тогда	
			ПослеОплаты();
		КонецЕсли;	

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
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
КонецПроцедуры



&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СП_РаботаСДокументами.ПриСозданииНаСервере(ЭтотОбъект);
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ИспользоватьПодключаемоеОборудование 	= ПодключаемоеОборудованиеВызовСервера.ИспользоватьПодключаемоеОборудование();
	УстройствоПечати 						= ПодключаемоеОборудованиеВызовСервера.ВернутьИдентификаторУстройстваДляПечатиДокументов();
	ПересчитатьСумму();
	
	Если ЗначениеЗАполнено(Параметры.Участник) Тогда
		Если ТипЗнч(Параметры.Участник) = Тип("Число") Тогда
			Объект.Участник =  Справочники.Участники.НайтиПоКоду(Параметры.Участник);
		Иначе
			Объект.Участник = Параметры.Участник;
		КонецЕсли;			
		
	КонецЕсли;	
	ЗакрытьПослеОплаты	= константы.ЗакрыватьДокументПослеОплаты.Получить();	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды			
	ПересчитатьСумму();
	//Сканер штрихкода
   СтоСП_Клиент.ПодключитьСканерШК(УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если не ЗначениеЗаполнено(Объект.ВидОплаты) Тогда
		Объект.ВидОплаты = ПредопределенноеЗначение("Перечисление.ФормыОплаты.Наличные");
	КонецЕсли;	
КонецПроцедуры
#КонецОбласти


#Область Подсистемы
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
Процедура ОплатитьНаличными(Команда)
	ПринятьОплату(ПредопределенноеЗначение("Перечисление.ФормыОплаты.Наличные"));
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
#КонецОбласти	
