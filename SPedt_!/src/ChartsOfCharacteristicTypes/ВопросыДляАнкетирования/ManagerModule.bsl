#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления.

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// которые необходимо обновить на новую версию.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВопросыДляАнкетирования.Ссылка
		|ИЗ
		|	ПланВидовХарактеристик.ВопросыДляАнкетирования КАК ВопросыДляАнкетирования
		|ГДЕ
		|	(ВопросыДляАнкетирования.ВидПереключателя = ЗНАЧЕНИЕ(Перечисление.ВидыПереключателяВАнкетах.ПустаяСсылка)
		|			ИЛИ ВопросыДляАнкетирования.ВидФлажка = ЗНАЧЕНИЕ(Перечисление.ВидыФлажкаВАнкетах.ПустаяСсылка))";
	Результат = Запрос.Выполнить().Выгрузить();
	МассивСсылок = Результат.ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

// Заполнить значение нового реквизита ВидПереключателя у плана видов характеристик ВопросыДляАнкетирования.
// 
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "ПланВидовХарактеристик.ВопросыДляАнкетирования");
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			
			ЗаполнитьНовыеРеквизиты(Выборка.Ссылка);
			
		Исключение
			// Если не удалось обработать объект, повторяем попытку снова.
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать вопрос для анкетирования: %1 по причине:
					|%2'"), 
					Выборка.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.ПланыВидовХарактеристик.ВопросыДляАнкетирования, Выборка.Ссылка, ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "ПланВидовХарактеристик.ВопросыДляАнкетирования");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет значения новых реквизитов ВидПереключателя и ВидФлажка у переданного объекта.
//
Процедура ЗаполнитьНовыеРеквизиты(ВопросДляАнкетирования)
	
	НачатьТранзакцию();
	Попытка
	
		// Блокируем объект от изменения другими сеансами.
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("ПланВидовХарактеристик.ВопросыДляАнкетирования");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ВопросДляАнкетирования);
		Блокировка.Заблокировать();
		
		Объект = ВопросДляАнкетирования.ПолучитьОбъект();
		
		// Если объект ранее был удален или обработан другими сеансами, пропускаем его.
		Если Объект = Неопределено Тогда
			ОтменитьТранзакцию();
			Возврат;
		КонецЕсли;
		Если Объект.ВидПереключателя <> Перечисления.ВидыПереключателяВАнкетах.ПустаяСсылка() И Объект.ВидФлажка <> Перечисления.ВидыФлажкаВАнкетах.ПустаяСсылка() Тогда
			ОтменитьТранзакцию();
			Возврат;
		КонецЕсли;
		
		// Обработка объекта.
		Если Объект.ВидПереключателя = Перечисления.ВидыПереключателяВАнкетах.ПустаяСсылка() Тогда
			Объект.ВидПереключателя = Перечисления.ВидыПереключателяВАнкетах.Переключатель;
		КонецЕсли;
		
		Если Объект.ВидФлажка = Перечисления.ВидыФлажкаВАнкетах.ПустаяСсылка() Тогда
			Объект.ВидФлажка = Перечисления.ВидыФлажкаВАнкетах.Флажок;
		КонецЕсли;
		
		// Запись обработанного объекта.
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли