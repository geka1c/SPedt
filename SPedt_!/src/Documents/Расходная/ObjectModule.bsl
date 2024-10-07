
Процедура ОбработкаПроведения(Отказ, Режим)
	
	
	#Область ПравильноеПроведение
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, Режим);
	Документы.Расходная.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ДополнительныеСвойства.Вставить("ЭтоНовый",ЭтоНовый());
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СП_ДвиженияСервер.ПровестиПроверитьОтрицательныеОстаткиОстаткиТоваров(ДополнительныеСвойства,Движения, Отказ);
	Если Отказ Тогда Возврат; КонецЕсли;

	СтоСПОбмен_Общий.ОтразитьСтоСПОбмен_РН(ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьПродажи(ДополнительныеСвойства, Движения, Отказ);
    СП_ДвиженияСервер.ОтразитьРасход(ДополнительныеСвойства, Движения, Отказ);
	ПроведениеСерверСП.ОтразитьДвиженияПоТаблице(ДополнительныеСвойства, Движения, "ТоварыНаСкладах", Отказ);
	
	#КонецОбласти
	
	
		
	Движения.ОстаткиТоваров.Записывать = Истина;
	Движения.Расход.Записывать = Истина;

	

		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)   
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения и 
		ПараметрыСеанса.РазрешитьИзменения <> Ссылка и 
		не Константы.РасходнаяПометкаНаУдаление.Получить() Тогда
		Отказ =  Истина;
		Возврат;
	Иначе
		УстановитьПривилегированныйРежим(Истина);
		ПараметрыСеанса.РазрешитьИзменения = Документы.Расходная.ПустаяСсылка();;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
//	Если ВидОплаты = Перечисления.ФормыОплаты.ПлатежнаяКарта и 
//		не ЗначениеЗаполнено(НомерКарты) и 
//		не константы.ПлатежныйТерминалБезПодключения.Получить() Тогда
//		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Выбран вид оплаты ""Платежная карта"", но оплата не выполнена");
//		Отказ =  истина;
//		
//		
//	КонецЕсли;
	
	Если аСППрверки.ПроверитьБлокировкуУчастника(Участник) и РежимЗаписи<>РежимЗаписиДокумента.ОтменаПроведения  Тогда
		Отказ = Истина;
	КонецЕсли;
	ЗаполнитьШК(Покупки);
КонецПроцедуры


Процедура ЗаполнениеКодов() Экспорт
	для Каждого стр из Покупки Цикл
		стр.КодЗаказа	= ПолучитьКодВыдачиПокупки(стр.Покупка, Участник);
	КонецЦикла;	
КонецПроцедуры	

Функция 	ЗаполнитьОстатками(Период = Неопределено, ПомечатьСтроки = Ложь) Экспорт
	Если Период = Неопределено Тогда
		ДатаДокумента = КонецДня(Дата);
	Иначе	
		ДатаДокумента = Период;		
	КонецЕсли;	
	тз = СП_РаботаСДокументами.ТаблицаРасходной(ДатаДокумента,Участник);
	ЗаполнитьГородаСП(ТЗ);
	ЗаполнитьШК(Тз);
	Покупки.Очистить();
	Для каждого стр из ТЗ Цикл
		КодЗаказа = ПолучитьКодВыдачиПокупки(стр.Покупка, Участник);
		если стр.негабарит Тогда 
			новСтрока					= Покупки.Добавить();			
			ЗаполнитьЗначенияСвойств(новСтрока,стр);
			новСтрока.КодЗаказа			= КодЗаказа;
		Иначе
			Для инд=1 по стр.Количество Цикл
				новСтрока				=Покупки.Добавить();
				ЗаполнитьЗначенияСвойств(новСтрока,стр);
				новСтрока.КодЗаказа		= КодЗаказа;
				новСтрока.Количество	= 1;
			КонецЦикла;
		КонецЕсли
	КонецЦикла;
	
	Для каждого стр из Покупки Цикл
		Если стр.БесплатнаяВыдача Тогда
			Если стр.ОплаченоУчастником Тогда
				ПредоплатаУчастник = ПредоплатаУчастник+ стр.ОплачиваетОрганизатор;	
			Иначе
				ПредоплатаОрганизатор = ПредоплатаОрганизатор+ стр.ОплачиваетОрганизатор;	
			КонецЕсли;
		КонецЕсли;
		стр.Подбор = ПомечатьСтроки;
	КонецЦикла;	
	Если ПомечатьСтроки И Покупки.Количество()>0 Тогда
		ВидОплаты = Перечисления.ФормыОплаты.Наличные;
		ПоискЗаказа = стр.КодЗаказа; 
		РассчитатьСтоимость();
	КонецЕсли;

//	СтоимостьИтого 					= Покупки.Итог("СтоимостьИтого") - ПредоплатаОрганизатор - ПредоплатаУчастник + ПоискНикаСтоимость;

КонецФункции

Процедура РассчитатьСтоимость()
	СтоимостьИтого	= 0;
	ПредоплатаОрганизатор=0;							         
	ПредоплатаУчастник = 0;

	
	Для каждого стр из Покупки Цикл
		
		СтоимостьИтого	= СтоимостьИтого + 	стр.ОплачиваетУчастник;
		Если стр.БесплатнаяВыдача Тогда
			Если стр.ОплаченоУчастником Тогда
				ПредоплатаУчастник = ПредоплатаУчастник+ стр.ОплачиваетОрганизатор;	
			Иначе
				ПредоплатаОрганизатор = ПредоплатаОрганизатор+ стр.ОплачиваетОрганизатор;	
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Для каждого стр из Товары Цикл	
		СтоимостьИтого	= СтоимостьИтого + стр.Сумма;
	КонецЦикла;	
	ВыбранныеПосылки = Покупки.найтистроки(Новый Структура("Подбор", Истина));
	Если ВыбранныеПосылки.Количество()>0 Тогда
		СтоимостьИтого	= СтоимостьИтого + ПоискНикаСтоимость;
	КонецЕсли;		
	Если Списать Тогда
		СтоимостьИтого	= 0;
	КонецЕсли;	
	КоличествоПомеченныхСтрок	= ВыбранныеПосылки.Количество();
КонецПроцедуры


функция ПолучитьКодВыдачиПокупки(Покупка, Участник)
	Если (	ТипЗнч(Покупка)=Тип("СправочникСсылка.Покупки") или
			ТипЗнч(Покупка)=Тип("СправочникСсылка.Пристрой"))  и
			ЗначениеЗаполнено(Покупка.secureCode) Тогда
		х			= новый ХешированиеДанных(ХешФункция.CRC32);
		х.Добавить(СтрЗаменить(Строка(Покупка.Код)+"_"+Строка(Участник.Код)+"_"+Покупка.secureCode," ",""));
		КодВыдачи	= Лев(СтрЗаменить(Строка(х.ХешСумма)," ",""),4);
	ИначеЕсли ТипЗнч(Покупка)=Тип("СправочникСсылка.Посылки") и ЗначениеЗаполнено(Покупка.secureCode)  Тогда
		КодВыдачи = Покупка.secureCode;
	Иначе 
		КодВыдачи = "Нет кода!";		
	КонецЕсли;	
	Возврат КодВыдачи;
КонецФункции	


Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	массСтрок = покупки.НайтиСтроки(новый структура("Оплачен",Ложь));
	Для каждого элем из массСтрок Цикл
		Если элем.Оплатить Тогда Продолжить КонецЕсли;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Позиция № """+элем.НомерСтроки+
		""" не оплачена ";
		Сообщение.Поле="Заказы["+(элем.НомерСтроки-1)+"].Оплачен";
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Сообщить();
		Отказ=Истина;		
	КонецЦикла	
	
	//Запрос = Новый Запрос;
	//Запрос.Текст =          //Проверка оплачен.неоплачен
	//	"ВЫБРАТЬ
	//	|	РасходнаяПокупки.НомерСтроки,
	//	|	РасходнаяПокупки.МестоХранения,
	//	|	РасходнаяПокупки.Покупка,
	//	|	РасходнаяПокупки.Количество
	//	|ИЗ
	//	|	Документ.Расходная.Покупки КАК РасходнаяПокупки
	//	|Где Ссылка=&Ссылка И НЕ РасходнаяПокупки.Оплачен 
	//	|И НЕ РасходнаяПокупки.Оплатить
	//	|И НЕ РасходнаяПокупки.Потерян";
	//Запрос.УстановитьПараметр("Ссылка",Ссылка);	
	//Результат = Запрос.Выполнить();

	//Выборка = Результат.Выбрать();

	//Пока Выборка.Следующий() Цикл
	//		Сообщение = Новый СообщениеПользователю;
	//		Сообщение.Текст = "Позиция № """+Выборка.НомерСтроки+
	//		 	""" не оплачена ";
	//		Сообщение.Поле="Заказы["+(Выборка.НомерСтроки-1)+"].Оплачен";
	//		Сообщение.УстановитьДанные(ЭтотОбъект);
	//		Сообщение.Сообщить();
	//		Отказ=Истина;
	//КонецЦикла;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	НомерЧекаККМ=0;
	НомерСменыККМ=0;
	
	Архивный=Ложь;
	СтатусККМ=Перечисления.СтатусыЧековККМ.ПустаяСсылка();
	Напечатано=Ложь;
КонецПроцедуры


Процедура ЗаполнитьШК(Тз)
	массСтрок=Тз.НайтиСтроки(Новый Структура("ШК",Справочники.Мегаордера.ПустаяСсылка()));
	Свояточка=Константы.СвояТочка.Получить();
	Для каждого стр из массСтрок Цикл
		стр.ШК	= СП_Штрихкоды.ПолучитьМегаордер(стр.Покупка,Участник,Константы.СвояТочка.Получить());
	КонецЦикла;
КонецПроцедуры	

Процедура ЗаполнитьГородаСП(ТЗ)
	массШКБезГорода=тз.НайтиСтроки(новый Структура("ГородСП",Справочники.ГородаСП.ПустаяСсылка()));
	Если массШКБезГорода.количество()>0 Тогда
		сисокШК=новый СписокЗначений;
		Для каждого элем из массШКБезГорода Цикл
			сисокШК.Добавить(элем.ШК);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры	

Функция ДобавитьТовар(Товар) Экспорт
	Если ТипЗнч(Товар) = Тип("СправочникСсылка.КартыУчастников") Тогда
		строка_товар 				= Товары.Добавить();
		строка_товар.Номенклатура 	= Товар;
		строка_товар.Количество 	= 1;
		строка_товар.Цена  			= Константы.СтоимостьКартыУчастника.Получить();
		строка_товар.Сумма  		= строка_товар.Цена*строка_товар.Количество;
		
		СтоимостьИтого=Покупки.Итог("ОплачиваетУчастник")+ПоискНикаСтоимость+Товары.Итог("Сумма");
		Возврат Истина;
	ИначеЕсли ТипЗнч(Товар) = Тип("СправочникСсылка.Номенклатура") Тогда
		масс_Строк = Товары.НайтиСтроки(новый Структура("Номенклатура",Товар));
		Если масс_Строк.Количество()>0 тогда
			стр_товара = масс_Строк[0];
			количество_до = стр_товара.Количество;
		Иначе	
			стр_товара = Товары.Добавить();
			количество_до = 0;
		Конецесли;	
		стр_товара.Номенклатура	= Товар;
		стр_товара.Количество 	= количество_до + 1;
		стр_товара.Цена  		= Товар.Цена;
		стр_товара.Сумма  		= стр_товара.Цена*стр_товара.Количество;
	    СтоимостьИтого=Покупки.Итог("ОплачиваетУчастник")+ПоискНикаСтоимость+Товары.Итог("Сумма");

		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
КонецФункции	