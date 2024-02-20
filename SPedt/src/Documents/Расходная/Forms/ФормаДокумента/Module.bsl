

#Область ШтрихКоды

&НаКлиенте
Процедура 	ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если 	ИмяСобытия 	= "ScanData"					и
			Источник 	= "ПодключаемоеОборудование" 	и
			Параметр.Найти("Обработано") 	= Неопределено и
	   		ВводДоступен()   Тогда
			
			ШК = СтоСП_Клиент.ПолучитьШКизПараметров(Параметр);
			ОбработатьШКнаКлиенте(ШК);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура 	ОбработатьШКНаКлиенте(ШК)
	ДанныеШК    = СП_Штрихкоды.ПолучитьДанныеПоШК(ШК);
	Если ДанныеШК = неопределено Тогда Возврат; КонецЕсли;
	Если Строка(ДанныеШК.Тип) 	= "Карта участника (22)" Тогда
		Если Строка(ДанныеШК.Статус) <> "Не зарегистрирована" Тогда	
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Продать можно только не зарегестрированную карту."+Символы.ПС+
															  "карта: "		+ ДанныеШК.КартаУчастника+символы.ПС+
															  "участника: "	+ ДанныеШК.Владелец+ символы.ПС+		
															  "в статусе: " + Строка(ДанныеШК.Статус));
			ТоварДобавлен	= Ложь; 
		ИначеЕсли ЗначениеЗаполнено(ДанныеШК.Владелец) и
				  ДанныеШК.Владелец <> Объект.Участник	Тогда		
				  
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Карта уже привязана к другому участнику."+Символы.ПС+
															  "карта: "		+ ДанныеШК.КартаУчастника+символы.ПС+
															  "участника: "	+ ДанныеШК.Владелец+ символы.ПС+		
															  "в статусе: " + Строка(ДанныеШК.Статус));
			ТоварДобавлен	= Ложь; 
				
		иначе 
			СП_РаботаСоСправочниками.ОбновитьКартуУчастника(ДанныеШК.КартаУчастника, 
														новый структура("Участник, Владелец",Объект.Участник, Объект.Участник) );
	
			ТоварДобавлен	= ДобавитьТовар(ДанныеШК.КартаУчастника);
		КонецЕсли;	
		Если ТоварДобавлен Тогда
			СтоСП_Клиент.СигналДинамика();
			Элементы.ГруппаСтраницы.ТекущаяСтраница	= Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.гпТовары;
		КОнецЕсли;	
	ИначеЕсли Строка(ДанныеШК.Тип) 	= "Номенклатура (61)" Тогда	
		ТоварДобавлен	= ДобавитьТовар(ДанныеШК.Номенклатура);
		Если ТоварДобавлен Тогда
			СтоСП_Клиент.СигналДинамика();
			Элементы.ГруппаСтраницы.ТекущаяСтраница	= Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.гпТовары;
		КОнецЕсли;
	ИначеЕсли Строка(ДанныеШК.Тип) = "Действие по ШК (66)"   Тогда
		Если ТолькоПросмотр тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Документ уже оплачен!"); 
			Возврат; 
		КонецЕсли;
		Если	  ДанныеШК.Действие =  "ОплатаБезНаличная" Тогда	
 			ОплатитьКартой(Неопределено);
 		ИначеЕсли ДанныеШК.Действие =  "ОплатаНаличная" Тогда
			ОплатитьНаличными(Неопределено);
		КонецЕсли;			
	ИначеЕсли Строка(ДанныеШК.Тип) = "Сотрудник (55)" 		Тогда	
		ЗакрыватьДокумент = (сред(шк,8,2) = "01");
		Если ДвухЭтапнаяВыдача Тогда
			СобратьЗаказ(ДанныеШК.Сотрудник, ЗакрыватьДокумент);
		Иначе
			Объект.Ответственный = ДанныеШК.Сотрудник;
			ОплатитьНаличными(Неопределено);
		КонецЕсли;	
		//Если СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(этотОбъект,,ДанныеШК.Сотрудник) Тогда
		//	Закрыть();
		//КонецЕсли;		
	КонецЕсли;
КонецПроцедуры // ОбработатьШКНаКлиенте()

Функция ДобавитьТовар(ПараметрыТовара)
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.Расходная"));
	ТоварДобавлен = об.ДобавитьТовар(ПараметрыТовара);
	ЗначениеВДанныеФормы(об,Объект);
	Возврат ТоварДобавлен;
КонецФункции	

&НаКлиенте
Процедура 	ВвестиШтрихКодВручную(Команда)
	ОткрытьФорму("ОбщаяФорма.ФормаВводаШК",,ЭтотОбъект,,,,Новый ОписаниеОповещения("ВвестиШтрихКодВручную_Завершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура 	ВвестиШтрихКодВручную_Завершение(ШК, ДополнительныеПараметры) Экспорт
	ОбработатьШКнаКлиенте(ШК);
КонецПроцедуры	

#КонецОбласти

#Область Команды

&НаКлиенте
Процедура ПодгрузитьПокупки(Команда)
	ПерезаполнитьКоды();
КонецПроцедуры

Процедура ПерезаполнитьКоды()
	
	СписокКодовПокупок= новый СписокЗначений;
	СписокКодовЗаказов= новый СписокЗначений;
	Для каждого стр из объект.Покупки Цикл
		Если ТипЗнч(стр.Покупка)=Тип("СправочникСсылка.Покупки") Тогда
			СписокКодовПокупок.Добавить(Строка(стр.Покупка.Код));
		ИначеЕсли ТипЗнч(стр.Покупка)=Тип("СправочникСсылка.Заказы") Тогда
			СписокКодовЗаказов.Добавить(Строка(стр.Покупка.Код));
		КонецЕсли;	
	КонецЦикла;
	
	//СписокКодовСправочника.ЗагрузитьЗначения(Объект.Покупки.Выгрузить(,"ПокупкаСпр").ВыгрузитьКолонку("ПокупкаСпр"));
	Если СписокКодовПокупок.Количество()>0 Тогда
		СтоСПОбмен_Покупки.Загрузить(СписокКодовПокупок);
		//аспПроцедурыОбменаДанными.ПолучитьПокупкиПоКодам(СписокКодовПокупок);
	КонецЕсли;
	Если СписокКодовЗаказов.Количество()>0 Тогда
		аспПроцедурыОбменаДанными.ПолучитьЗапросомЗаказы(СписокКодовЗаказов);
	КонецЕсли;

	
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.Расходная"));
	об.заполнениеКодов();
	ЗначениеВДанныеФормы(об,Объект);
	
КонецПроцедуры	

&НаКлиенте
Процедура ИсторияДоставки(Команда)
//	ИсторияЗаказов	= ИсторияДоставкиНаСервере(Элементы.Покупки.ТекущиеДанные.ШК);
	ОткрытьФорму(	"Отчет.ИсторияЗаказов.Форма.ФормаОтчета",
					новый структура("мегаордер, СформироватьПриОткрытии",Элементы.Покупки.ТекущиеДанные.ШК, истина),
					ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
					
	
КонецПроцедуры


&НаКлиенте
Процедура Оплатить(Команда)
	Элементы.ГруппаОплата.Видимость = истина;
КонецПроцедуры



#КонецОбласти

#Область Печать

Функция  ПолучитьКомандуПечати(ИмяКоманды)
	
	Для каждого ком из ЭтаФорма.Команды Цикл
		Если ком.Заголовок=ИмяКоманды Тогда
			Возврат ком.Имя;
		КонецЕсли;
	КонецЦикла;	
КонецФункции

&НаСервереБезКонтекста
Функция КолвоЧеков()
	Если Константы.ЧекСборкиНеПечатать.Получить() Тогда
		Возврат 0;
	КонецЕсли;	
	колво=Константы.КоличествоЧековВыдачи.Получить();
	колво=?(Колво=0,1,колво);
	
	
	Возврат колво;
КонецФункции // КолвоЧеков()

 
&НаКлиенте
Функция  ЧекНЗ(Команда) Экспорт
	СтоСП_Печать_Клиент.ЧекНЗРасходная(новый Структура("Форма", этотОбъект),Истина);
КонецФункции



#КонецОбласти

#Область ФискализацияЧека 

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
		Иначе
 			//Проверка Печати фискального чека после опаты
			ТекстОшибки	=	"Ошибка 4 (проверка оплат). Сообщите Администратору";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		КонецЕсли;
	ИначеЕсли Объект.СсылочныйНомер <>	"" Тогда
		//Проверка Печати фискального чека после опаты
		ТекстОшибки	=	"Ошибка 3 (проверка оплат). Сообщите Администратору";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры



&НаКлиенте
Процедура 	ФискализироватьЧекВыполнить(Команда)
	Если Объект.СсылочныйНомер <> "" Тогда
		Объект.ВидОплаты = ПредопределенноеЗначение("Перечисление.ФормыОплаты.ПлатежнаяКарта");
	КонецЕсли;	
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

	Если Объект.Списать Тогда 
		//Проверка Печати фискального чека после опаты
		ТекстОшибки	=	"Ошибка 5 (проверка оплат). Сообщите Администратору";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		
		Возврат 
	
	КонецЕсли;
	ЭтаФорма.Доступность 	= Ложь;
	
	//ОбщиеПараметры 		 	= ПолучитьДанныеЧека(Параметры);
	данныеформы				= Объект;
	ОбщиеПараметры 		 	= СП_ККТ.ПолучитьШаблонЧека(УстройствоПечати, данныеформы, Печатать);
	Если ОбщиеПараметры = неопределено Тогда Возврат; КонецЕсли;
	ОписаниеОповещения 		= Новый ОписаниеОповещения("ФискализацияЧека_Завершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьФискализациюЧекаНаФискальномУстройстве(ОписаниеОповещения, УникальныйИдентификатор, ОбщиеПараметры, ?(УстройствоПечати.Пустая(), Неопределено, УстройствоПечати));

КонецПроцедуры

&НаКлиенте
Процедура 	ФискализацияЧека_Завершение(РезультатВыполнения, Параметры) Экспорт
	ЭтаФорма.Доступность = Истина;
	Если РезультатВыполнения.Результат Тогда
		Объект.НомерСменыККМ = РезультатВыполнения.ВыходныеПараметры[0];
		Объект.НомерЧекаККМ  = РезультатВыполнения.ВыходныеПараметры[1];
		Объект.СтатусККМ 		 = ПредопределенноеЗначение("Перечисление.СтатусыЧековККМ.Фискализирован");
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
Функция 	ПроверитьЗаполнениеДокумента()
	
	Результат = Истина;
	
	Текст = "";
	Если Объект.Покупки.Количество() = 0 и  Объект.Товары.Количество()=0 Тогда
		Текст = Текст + НСтр("ru = 'Не выбрано ни одного заказа'");
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




#КонецОбласти


&НаКлиенте
Процедура СобратьЗаказэКоманда(Команда)
	
	СобратьЗаказ();
	
КонецПроцедуры

&НаКлиенте
Процедура СобратьЗаказ(Сотрудник = Неопределено, ЗакрыватьДокумент = ложь)
	Если ПроверитьЗаполнение() Тогда
		Объект.Напечатано	= Истина;
		Если СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(этотОбъект,Новый структура("РежимЗаписи", РежимЗаписиДокумента.Запись),Сотрудник) Тогда
			спПочтовыеСообщения.ОтправитьЧекРасходной(объект.Ссылка);
			чеков	= КолвоЧеков();
			Для инд = 1 по чеков Цикл 
				командаПечати		= ПолучитьКомандуПечати("Чек");
				УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(ЭтаФорма.Команды[командаПечати], ЭтотОбъект, Объект);
			КонецЦикла;
			Если ЗакрыватьДокумент Тогда
				Закрыть();
			КонецЕсли
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПослеОплаты()
	
	Если не ДвухЭтапнаяВыдача и не Объект.Напечатано Тогда
		чеков	= КолвоЧеков();
		Для инд = 1 по чеков Цикл 
			командаПечати		= ПолучитьКомандуПечати("Чек");
			УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(ЭтаФорма.Команды[командаПечати], ЭтотОбъект, Объект);
		КонецЦикла;
		Если не Объект.Напечатано Тогда
			Объект.Напечатано	= Истина;
			СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(ЭтотОбъект);
		КонецЕсли;	
	КонецЕсли;
	
	ОповеститьОбИзменении(Объект.Ссылка);
	ФискализироватьЧекАвтоПослеЗаписи();
	УстановитьВидимость();
	Если ЗакрытьПослеОплаты Тогда
		Закрыть();
	КонецЕсли;	
КонецПроцедуры	

&НаКлиенте
Процедура ОплатитьНаличными(Команда)
	ПринятьОплату(ПредопределенноеЗначение("Перечисление.ФормыОплаты.Наличные"));
КонецПроцедуры



#Область Эквайринг
	
&НаКлиенте
Процедура ВозвратОплатыКартой(Команда)
	Сумма = Объект.СтоимостьИтого;//Объект.Покупки.Итог("СтоимостьИтого")+Объект.ПоискНикаСтоимость;
	Если Вопрос("Вы уверенны что необходимо отменить оплату по карте?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
		Возврат;
	Конецесли;
	ОчиститьСообщения();

	Если не Объект.ОплатаВыполнена Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Для данного документа не выполнена оплата платежной картой.'"));
		Возврат;
	КонецЕсли;

		ПараметрыОперации=МенеджерОборудованияКлиент.ПараметрыВыполненияЭквайринговойОперации();
		ПараметрыОперации.ТипТранзакции		= "AuthorizeRefund";
		ПараметрыОперации.СуммаОперации 	= Сумма;
		ПараметрыОперации.НомерЧека			= "";
		ПараметрыОперации.НомерЧекаЭТ		= "";
		ПараметрыОперации.НомерКарты		= Объект.НомерКарты;
		ПараметрыОперации.СсылочныйНомер 	= Объект.СсылочныйНомер;
		
		
		

	МенеджерОборудованияКлиент.ПредложитьВыбратьУстройство(
		Новый ОписаниеОповещения("ОплатитьКартойПредложитьВыбратьЭквайринговыйТерминалЗавершение", ЭтотОбъект, ПараметрыОперации),
		"ЭквайринговыйТерминал",
		НСтр("ru='Выберите эквайринговый терминал'"),
		НСтр("ru='Эквайринговый терминал не подключен'"));
КонецПроцедуры

&НаКлиенте
Процедура ОтменаОплатыКартой(Команда)
	Сумма = Объект.СтоимостьИтого;//Объект.Покупки.Итог("СтоимостьИтого")+Объект.ПоискНикаСтоимость;
	Если Вопрос("Вы уверенны что необходимо отменить оплату по карте?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
		Возврат;
	Конецесли;
	ОчиститьСообщения();

	Если не Объект.ОплатаВыполнена Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Для данного документа не выполнена оплата платежной картой.'"));
		Возврат;
	КонецЕсли;

		ПараметрыОперации=МенеджерОборудованияКлиент.ПараметрыВыполненияЭквайринговойОперации();
		ПараметрыОперации.ТипТранзакции		= "AuthorizeVoid";
		ПараметрыОперации.СуммаОперации 	= Сумма;
		ПараметрыОперации.НомерЧека			= "";
		ПараметрыОперации.НомерЧекаЭТ		= "7";
		ПараметрыОперации.НомерКарты		= Объект.НомерКарты;
		ПараметрыОперации.СсылочныйНомер 	= Объект.СсылочныйНомер;
		
		
		

	МенеджерОборудованияКлиент.ПредложитьВыбратьУстройство(
		Новый ОписаниеОповещения("ОплатитьКартойПредложитьВыбратьЭквайринговыйТерминалЗавершение", ЭтотОбъект, ПараметрыОперации),
		"ЭквайринговыйТерминал",
		НСтр("ru='Выберите эквайринговый терминал'"),
		НСтр("ru='Эквайринговый терминал не подключен'"));

КонецПроцедуры
	


&НаКлиенте
Процедура ОплатитьКартой(Команда)     
	Если ПлатежныйТерминалБезПодключения Тогда
		ПринятьОплату(ПредопределенноеЗначение("Перечисление.ФормыОплаты.ПлатежнаяКарта"));		
	Иначе	
		ОплатитьБезнал(ПредопределенноеЗначение("Перечисление.ФормыОплаты.ПлатежнаяКарта"));
	КонецЕсли;	
КонецПроцедуры
	
&НаКлиенте
Процедура ОплатаQR(Команда)
	ПринятьОплату(ПредопределенноеЗначение("Перечисление.ФормыОплаты.ОплатаQR"));
КонецПроцедуры

&НаКлиенте
Процедура ПринятьОплату(ВидОпреации)
		Если аСППрверки.ПроверитьБлокировкуУчастника(объект.Участник) = ложь Тогда
		Объект.ВидОплаты = ВидОпреации;
		ПараметрыЗаписи = Новый Структура("РежимЗаписи, РежимПроведения, НеПроверятьОтветственного",
		РежимЗаписиДокумента.Проведение,
		РежимПроведенияДокумента.Оперативный,
		Истина);
		Если СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(ЭтотОбъект) Тогда	
			ПослеОплаты();
			спПочтовыеСообщения.ОтправитьЧекРасходной(объект.Ссылка)
		КонецЕсли;	
	КОнецЕсли;
КонецПроцедуры	

&НаКлиенте
Процедура ОплатитьБезнал(ВидОперации)
	Если Объект.ПометкаУдаления Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Документ помечен на удаление. Оплата не выполнена!");
		Возврат;
	КонецЕсли;	
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
			
			//Проверка Печати фискального чека после опаты
			ТекстОшибки	=	"Ошибка 1 (проверка оплат). Сообщите Администратору";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
			
		КонецЕсли;
		
		
		Если СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(ЭтотОбъект) Тогда
			Если Результат.ТипТранзакции = "AuthorizeSales" Тогда
				ПослеОплаты();
				//НапечататьЧекПослеЗаписи();
				//ФискализироватьЧекАвтоПослеЗаписи();
				//ОповеститьОбИзменении(Объект.Ссылка);
				//Закрыть();//Элементы.ФискализацияЧека.Доступность = Ложь;
			КонецЕсли;
		Иначе	
 			//Проверка Печати фискального чека после опаты
			ТекстОшибки	=	"Ошибка 2 (проверка оплат). Сообщите Администратору";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		КонецЕсли;
		//Сообщить("ОперацияВыполнена");
		
	Иначе
		Сообщить("При выполнении операции произошла ошибка "+Результат.ОписаниеОшибки);
		
	КонецЕсли;
КонецПроцедуры



////Сверка итогов
&НаКлиенте
Процедура СверкаИтогов(Команда)
	Если Вопрос("Вы уверенны что необходимо выполнить сверку итогов?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
		Возврат;
	Конецесли;


	ОчиститьСообщения();
	
	Если Объект.ОплатаВыполнена Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Для данного документа уже выполнена оплата платежной картой.'"));
		Возврат;
	КонецЕсли;

	ДополнительныеПараметры = Новый Структура;
	МенеджерОборудованияКлиент.ПредложитьВыбратьУстройство(
		Новый ОписаниеОповещения("ВыполнениеСверкиИтоговНаЭквайринговомТерминале", ЭтотОбъект, ДополнительныеПараметры),
		"ЭквайринговыйТерминал",
		НСтр("ru='Выберите эквайринговый терминал'"),
		НСтр("ru='Эквайринговый терминал не подключен'"));

КонецПроцедуры

&НаКлиенте
Процедура ВыполнениеСверкиИтоговНаЭквайринговомТерминале(ИдентификаторУстройстваЭТ, ДополнительныеПараметры) экспорт

	Если ИдентификаторУстройстваЭТ <> Неопределено Тогда
		
		ЭтаФорма.Доступность = Ложь;
		
		ОповещениеПриЗавершении = Новый ОписаниеОповещения("ВыполнениеСверкиИтоговНаЭквайринговомТерминалеЗавершение", ЭтотОбъект);
		МенеджерОборудованияКлиент.НачатьВыполнениеСверкиИтоговНаЭквайринговомТерминале(ОповещениеПриЗавершении, УникальныйИдентификатор, 
		ИдентификаторУстройстваЭТ, );
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнениеСверкиИтоговНаЭквайринговомТерминалеЗавершение(РезультатВыполнения, Параметры) Экспорт
 
   ЭтаФорма.Доступность = Истина;

   Если РезультатВыполнения.Результат Тогда
      ТекстСообщения = НСтр("ru = 'Операция завершена.'");
      Сообщить(ТекстСообщения); 
   Иначе 
      ТекстСообщения = НСтр("ru = 'При выполнении операции произошла ошибка:""%ОписаниеОшибки%"".'");
      ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", РезультатВыполнения.ОписаниеОшибки);
      Сообщить(ТекстСообщения);
   КонецЕсли;

КонецПроцедуры


#КонецОбласти

#Область СобытияФормы


&НаКлиенте
Процедура ПриОткрытии(Отказ)


    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
	Если не ЗначениеЗаполнено(Объект.КартаУчастника) Тогда
		ТекущийЭлемент=Элементы.ПоискЗаказа;
	 	Элементы.ПоискЗаказа.АктивизироватьПоУмолчанию=Истина;
	Иначе	
		ТекущийЭлемент=Элементы.ОплатитьНаличными;
	 	Элементы.ОплатитьНаличными.АктивизироватьПоУмолчанию=Истина;
	КонецЕсли;
	Элементы.ПокупкиГруппаРассчетСтоимости.Видимость = Ложь;
	
	//Сканер штрихкода
	СтоСП_Клиент.ПодключитьСканерШК(УникальныйИдентификатор);
	
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьРасчетСтоимости(Команда)
	Элементы.ПокупкиГруппаРассчетСтоимости.Видимость 	= не Элементы.ПокупкиГруппаРассчетСтоимости.Видимость;
	Элементы.ПокупкиОписание.Видимость 					= не Элементы.ПокупкиОписание.Видимость;
КонецПроцедуры


&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)  
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
    // СтандартныеПодсистемы.Печать
  //  УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект,Элементы.ГруппаПечать);
    // Конец СтандартныеПодсистемы.Печать	
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	Элементы.гпОплата.Видимость = Константы.ИспользоватьПризнакОплаты.Получить();
	
	
	Если Параметры.ЗаполнятьПоУчастнику Тогда
		Объект.Участник = Параметры.участник;
		Объект.Дата		= ТекущаяДата();
		Если Параметры.Свойство("ПоискНикаСтоимость") Тогда
			Объект.ПоискНикаСтоимость = Параметры.ПоискНикаСтоимость;
		КонецЕсли;
		Если Параметры.Свойство("КартаУчастника") Тогда
			Объект.КартаУчастника = Параметры.КартаУчастника;
		КонецЕсли;

		
		
		документОбъект 	= РеквизитФормыВЗначение("Объект");
		документОбъект.Заполнитьостатками();
		ЗначениеВДанныеФормы(документОбъект,Объект);
	КонецЕсли;
	
	
	ПерезаполнитьКоды();
	ИспользоватьПодключаемоеОборудование 	= ПодключаемоеОборудованиеВызовСервера.ИспользоватьПодключаемоеОборудование();
	УстройствоПечати 						= ПодключаемоеОборудованиеВызовСервера.ВернутьИдентификаторУстройстваДляПечатиДокументов();
	ПодсветкаКодовЗаказа();
	ПодсветкаСтрок();
	
	Параметры.Свойство("ОткрытьДляОплаты",ОткрытоДляОплаты);
	ДвухЭтапнаяВыдача	= ПолучитьФункциональнуюОпцию("ИспользоватьДвухЭтапнуюВыдачуЗаказа");
	ЗакрытьПослеОплаты	= константы.ЗакрыватьДокументПослеОплаты.Получить();                  
	ПлатежныйТерминалБезПодключения = Константы.ПлатежныйТерминалБезПодключения.Получить();
	
	Если Константы.ЧекСборкиНеПечатать.Получить() Тогда
		Объект.Напечатано = Истина;
	КонецЕсли;	
	
КонецПроцедуры


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если		аСПСлужебные.ПроверятьОтветственного() 					и  
			не 	ПараметрыЗаписи.свойство("НеПроверятьОтветственного") 	и
			не ЗначениеЗаполнено(Объект.Ответственный) 						Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Необходимо установить ответственного за выдачу!!!");
		отказ=Истина;
	КонецЕсли;	
	
	Если 	ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение и
		не 	ЗначениеЗаполнено(Объект.ВидОплаты) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбран вид оплаты!");
		отказ=Истина;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	УстановитьВидимость();
КонецПроцедуры



//////////////////

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Если не ЗначениеЗаполнено(Объект.КартаУчастника) и Объект.Покупки.Количество() > 0 Тогда
		ВсеКоды="";
		Для каждого стр из Объект.Покупки Цикл
			Если стр.КодЗаказа<>"Нет кода!" Тогда
				ВсеКоды=ВсеКоды+","+стр.КодЗаказа;
			Конецесли;	
		КонецЦикла;
		массКодов=СтрРазделить(ВсеКоды,",",Ложь);
		если  массКодов.Найти(Объект.ПоискЗаказа)=Неопределено и не Константы.РазрешитьВыдачуБезСверкиКодов.Получить() Тогда
			отказ= Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нужно подтвердить хотя бы один заказ!");
		КонецЕсли;
	КонецЕсли;
	
	
КонецПроцедуры


//////////////////////
&НаКлиенте
Процедура ПокупкиПриИзменении(Элемент)
	Если Объект.Списать Тогда
		Объект.СтоимостьИтого	= 0;
	Иначе	
		Объект.СтоимостьИтого	= 	Объект.Покупки.Итог("ОплачиваетУчастник")+
									Объект.ПоискНикаСтоимость+
									Объект.Товары.Итог("Сумма");
	КонецЕсли;	                               
	Объект.ПредоплатаОрганизатор=0;							         
	Объект.ПредоплатаУчастник = 0;
	Для каждого стр из Объект.Покупки Цикл
		Если стр.БесплатнаяВыдача Тогда
			Если стр.ОплаченоУчастником Тогда
				Объект.ПредоплатаУчастник = Объект.ПредоплатаУчастник+ стр.ОплачиваетОрганизатор;	
			Иначе
				Объект.ПредоплатаОрганизатор = Объект.ПредоплатаОрганизатор+ стр.ОплачиваетОрганизатор;	
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры
&НаКлиенте
Процедура ТоварыКоличествоЦенаПриИзменении(Элемент)
	Элементы.Товары.ТекущиеДанные.Сумма = Элементы.Товары.ТекущиеДанные.Цена * Элементы.Товары.ТекущиеДанные.Количество;
КонецПроцедуры


#КонецОбласти

#Область Вспомоготельные

&НаСервере
Процедура ПодсветкаСтрок()

    ЭтаФорма.УсловноеОформление.Элементы.Очистить();
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Покупки");
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Покупки.Оплачен");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = ложь;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.Желтый);	
	
	Если не ЗначениеЗаполнено(Объект.КартаУчастника) Тогда

		ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
		ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Покупки");
		ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Покупки.КодЗаказа");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение =  Новый ПолеКомпоновкиДанных("Объект.ПоискЗаказа");
		ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.КрасноФиолетовый);	
	КонецЕсли;

	
КонецПроцедуры // ПодсветкаСтрок()
 
&НаСервере
Процедура ПодсветкаКодовЗаказа()

	ЭтаФорма.УсловноеОформление.Элементы.Очистить();
	ЭлементУсловногоОформления 				= УсловноеОформление.Элементы.Добавить();
	ОформляемоеПоле 						= ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле 					= Новый ПолеКомпоновкиДанных("КодыЗаказов");
	ЭлементОтбора 							= ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение 			= Новый ПолеКомпоновкиДанных("Объект.Покупки.КодЗаказа");
	ЭлементОтбора.ВидСравнения 				= ВидСравненияКомпоновкиДанных.НачинаетсяС;
	ЭлементОтбора.ПравоеЗначение 			=  Новый ПолеКомпоновкиДанных("Объект.ПоискЗаказа");
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.КрасноФиолетовый);	
КонецПроцедуры 

Процедура УстановитьВидимость()

	
	Если 	не ЗначениеЗаполнено(Объект.ВидОплаты) Тогда
		Элементы.ГруппаСборЗаказа.Видимость 	= 	ДвухЭтапнаяВыдача 	и 	не 	ОткрытоДляОплаты ;
		Элементы.ГруппаОплата.Видимость 		= 	не ДвухЭтапнаяВыдача или 	ОткрытоДляОплаты;
	Иначе	
		Элементы.ГруппаСборЗаказа.Видимость 	= 	Ложь;
		Элементы.ГруппаОплата.Видимость 		= 	не ДвухЭтапнаяВыдача;
	КонецЕсли;
	
	элементы.гпКодЗаказа.Видимость					= не ЗначениеЗаполнено(Объект.КартаУчастника);
	элементы.ПоискЗаказа.Видимость					= не ЗначениеЗаполнено(Объект.КартаУчастника) и не Константы.РазрешитьВыдачуБезСверкиКодов.Получить();
	
	
	//ТолькоПросмотр 									= ?(ТолькоПросмотр,
	//													ТолькоПросмотр,
	//													( Объект.НомерЧекаККМ<>0) или 
	//													  (ЗначениеЗаполнено(Объект.ВидОплаты) и Объект.Проведен)
	//													);

	ТолькоПросмотр = Объект.Проведен;	
	
	Элементы.ФормаРазрешитьРедактирование.Видимость = ТолькоПросмотр;
	Элементы.УчастникРэйтинг.Видимость				= аСПНаСервере.ПоказыватьРейтингУчастника();
	
	всегоПокупок = Объект.Покупки.Итог("Количество");
	Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.гпДокумент.Заголовок=?(всегоПокупок=0,"Заказы","Заказы ("+всегоПокупок+")");
	
	всегоТоваров = Объект.Товары.Итог("Количество");
	Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.гпТовары.Заголовок=?(всегоТоваров=0,"Товары","Товары ("+всегоТоваров+")");
	
	Элементы.ОплатаQR.Видимость = Константы.ОплатаQRкодом.Получить()
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

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
    УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Объект);
КонецПроцедуры

//&НаКлиенте
//Процедура РазрешитьРедактирование(Команда)
//	Если (Объект.НомерЧекаККМ=0) Тогда
//		ТолькоПросмотр = Ложь;
//	Иначе
//		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Для документа зарегистрирован фискальный чек. Редактирование запрещено!");
//	КонецЕсли;	
//КонецПроцедуры

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)
	//ОткрытьФорму("ОбщаяФорма.ФормаОжиданиеВводаШтрихкода",,ЭтотОбъект,,,,Новый ОписаниеОповещения("ВвестиШтрихКодАдминистратора_Завершение", ЭтотОбъект),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ОткрытьФорму("ОбщаяФорма.РозрещениеРедактирования",новый структура("Документ", Объект.Ссылка),ЭтотОбъект,,,,Новый ОписаниеОповещения("ВвестиШтрихКодАдминистратора_Завершение", ЭтотОбъект),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры


&НаКлиенте
Процедура ВвестиШтрихКодАдминистратора_Завершение(ШК, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(ШК) =  Тип("Структура") и
		 ШК.Свойство("Администратор")	и
		 ШК.Администратор         			Тогда
		ТолькоПросмотр 									= Ложь;
		Если (Объект.НомерЧекаККМ <> 0) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Для документа зарегистрирован фискальный чек!");
		КонецЕсли;	
	 КонецЕсли;	 
КонецПроцедуры	




&НаКлиенте
Процедура ПоказатьПартиюПосылки(Команда)
	Если Элементы.Покупки.ТекущиеДанные <> Неопределено Тогда
		ОткрытьЗначение(Элементы.Покупки.ТекущиеДанные.Партия);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если 	Объект.ОплатаВыполнена и
			Объект.НомерСменыККМ =  0 Тогда
			
		ТекстПредупреждения =	"Выплнена безналичная оплата, а чек не фискализирован!!";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстПредупреждения);
		Отказ = Истина;
		
	КонецЕсли;	
	Оповестить("ЗакрытаРасходная");
КонецПроцедуры

&НаКлиенте
Процедура ПоискЗаказаПриИзменении(Элемент)
	ТекущийЭлемент=Элементы.ОплатитьНаличными;
 	Элементы.ОплатитьНаличными.АктивизироватьПоУмолчанию=Истина;
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
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Оповестить("ЗакрытаРасходная");
КонецПроцедуры

&НаКлиенте
Процедура Корректировка(Команда)
	корректируемыеЗаказы = Новый СписокЗначений;
	
	Для каждого элем из Элементы.Покупки.ВыделенныеСтроки Цикл
		строка = Объект.Покупки.НайтиПоИдентификатору(элем);
		корректируемыеЗаказы.Добавить(строка.Покупка);
	КонецЦикла;	
	
	
	Если Объект.Проведен Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Документ проведен корректировка не возможна");
		Возврат;
	КонецЕсли;
	ПараметрыЗаполнения= Новый Структура();
	ПараметрыЗаполнения.Вставить("ДатаОтчета", 		ТекущаяДата());
	ПараметрыЗаполнения.Вставить("Покупка", 		новый структура("ПравоеЗначение, Использование, ВидСравнения",корректируемыеЗаказы, Истина, ВидСравненияКомпоновкиДанных.ВСписке) );
	//		ПараметрыЗаполнения.Вставить("Партия", 			Объект.Ссылка);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияДвижения",ЭтаФорма);
	
	ОткрытьФорму("Документ.Движение.ФормаОбъекта",Новый структура("ПараметрыЗаполнения",ПараметрыЗаполнения) ,ЭтаФорма,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца  );
	
	
	
КонецПроцедуры


Процедура ПослеЗакрытияДвижения(результат, ДополнительныеПараметры) Экспорт
	об = РеквизитФормыВЗначение("Объект");	
	об.ЗаполнитьОстатками();
	ЗначениеВДанныеФормы(об,Объект);
	
КонецПроцедуры	



&НаКлиенте
Процедура ОтправитьЧек(Команда)
	//оповещениеОЗакрытии = Новый ОписаниеОповещения("ОтправитьЧекЗавершение",ЭтотОбъект);
	//
	//ПараметрыСообщения = спПочтовыеСообщения.ПараметыЧекаТранзита(Объект.Ссылка);
	//РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыСообщения,оповещениеОЗакрытии);
	
	если ЗначениеЗаполнено(Объект.Ответственный)  Тогда
		спПочтовыеСообщения.ОтправитьЧекРасходной(объект.Ссылка);
	Иначе
		ТекстСообщения = "Необходимо указать ответственного. У ответственного должна быт заполнена лектронная почта";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;	
КонецПроцедуры

Процедура ОтправитьЧекЗавершение(Результат, ДополнительныеПараметры)  Экспорт
	
   // ЗаполнитьПисьмоСчеком();
   // 
   //ИмяМетода = Метаданные.РегламентныеЗадания.ПолучениеИОтправкаЭлектронныхПисем.ИмяМетода;
   //Отбор = Новый Структура;
   //Отбор.Вставить("ИмяМетода", ИмяМетода);
   //Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
   //ФоновыеЗаданияОчистки = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
   //Если ФоновыеЗаданияОчистки.Количество() = 0 Тогда
   //   НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
   //     НСтр("ru = 'Запуск вручную: %1'"), Метаданные.РегламентныеЗадания.ПолучениеИОтправкаЭлектронныхПисем.Синоним);
   //   ФоновыеЗадания.Выполнить(ИмяМетода,,, НаименованиеФоновогоЗадания);
   //КонецЕсли;	
	
КонецПроцедуры	




