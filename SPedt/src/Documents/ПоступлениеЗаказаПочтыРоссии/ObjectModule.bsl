
Процедура ОбработкаПроведения(Отказ, Режим)
	//ЗаполнитьЗаказ();     
		
	// регистр ЗаказыТранспортныхКомпаний Приход
	Движения.ЗаказыТранспортныхКомпаний.Записывать = Истина;
	Движение = Движения.ЗаказыТранспортныхКомпаний.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.Заказ = Заказ;
	Движение.ТранспортнаяКомпания = Справочники.ТранспортныеКомпании.ПочтаРоссии;
	Движение.Количество = 1;
	Движение.Сумма = СтоимостьДоставки;  
	
	Движения.ЗаказыТранспортныхКомпанийОплаты.Записывать = Истина;
	Движение = Движения.ЗаказыТранспортныхКомпанийОплаты.Добавить();
	Движение.ВидОплаты = ВидОплаты;
	Движение.Период = Дата;
	Движение.Заказ = Заказ;
	Движение.ТранспортнаяКомпания = Справочники.ТранспортныеКомпании.ПочтаРоссии;
	Движение.Количество = 1;
	Движение.Сумма = СтоимостьИтого;
	


КонецПроцедуры

Процедура ЗаполнитьЗаказ()
	Если ЗначениеЗаполнено(НомерЗаказа) и не ЗначениеЗаполнено(Заказ) Тогда
		ЗаказСсылка = справочники.ЗаказыТК.НайтиПоКоду(НомерЗаказа);	
		Если ЗначениеЗаполнено(ЗаказСсылка) Тогда
			Заказ = ЗаказСсылка;
		Иначе	
			ЗаказОб = справочники.ЗаказыТК.СоздатьЭлемент();
			ЗаказОб.Владелец = Справочники.ТранспортныеКомпании.ПочтаРоссии;
			ЗаказОб.Код = НомерЗаказа;
			ЗаказОб.Наименование = "ПР " + НомерЗаказа;
			Попытка
				ЗаказОб.Записать();
				Заказ = ЗаказОб.Ссылка;
			Исключение
				ТекстОшибки = ОписаниеОшибки();
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(НомерЗаказа) и ЗначениеЗаполнено(Заказ) и  НомерЗаказа <> Заказ.Код	Тогда
		ЗаказОб = Заказ.ПолучитьОбъект();
		ЗаказОб.Код = НомерЗаказа;
		ЗаказОб.Наименование = "ПР " + НомерЗаказа;
		Попытка
			ЗаказОб.Записать();
			Заказ = ЗаказОб.Ссылка;
		Исключение
		КонецПопытки;
		
		
	КонецЕсли;	
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	ЗаполнитьЗаказ();
	Если не ЗначениеЗаполнено(Заказ) Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнен заказ!");
		
		Возврат;
	КонецЕсли;	
	
КонецПроцедуры

