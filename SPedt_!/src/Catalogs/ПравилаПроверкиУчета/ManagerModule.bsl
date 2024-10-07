
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиОбновления

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПравилаПроверкиУчета.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПравилаПроверкиУчета КАК ПравилаПроверкиУчета
	|ГДЕ
	|	ПравилаПроверкиУчета.Использование
	|	И ПравилаПроверкиУчета.Идентификатор В(&ИдентификаторыПроверок)");
	
	ПроверкиВеденияУчета = КонтрольВеденияУчетаСлужебныйПовтИсп.ПроверкиВеденияУчета().Проверки;
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Отключена", Истина);
	ОтключенныеПроверки = ПроверкиВеденияУчета.НайтиСтроки(ПараметрыОтбора);
	
	ИдентификаторыПроверок = Новый Массив;
	Для Каждого ОтключеннаяПроверка Из ОтключенныеПроверки Цикл
		ИдентификаторыПроверок.Добавить(ОтключеннаяПроверка.Идентификатор);
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ИдентификаторыПроверок", ИдентификаторыПроверок);
	Ссылки = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Ссылки);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	ОбъектМетаданных = Метаданные.Справочники.ПравилаПроверкиУчета;
	ПолноеИмяОбъекта = ОбъектМетаданных.ПолноеИмя();
	
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;
	
	ОтключаемаяПроверка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	Пока ОтключаемаяПроверка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			ОтключаемаяПроверкаСсылка = ОтключаемаяПроверка.Ссылка;
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ОтключаемаяПроверкаСсылка);
			
			Блокировка.Заблокировать();
			
			ОтключаемаяПроверкаОбъект = ОтключаемаяПроверкаСсылка.ПолучитьОбъект();
			ОтключаемаяПроверкаОбъект.Использование = Ложь;
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ОтключаемаяПроверкаОбъект);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось установить источник данных правила проверки %1.
				|Возможно он поврежден и не подлежит восстановлению.
				|
				|Информация для администратора: %2'"), 
				ОтключаемаяПроверкаСсылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				ОбъектМетаданных,
				ОтключаемаяПроверкаСсылка,
				Комментарий);
				
			КонецПопытки;
			
	КонецЦикла;
	
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта) Тогда
		ОбработкаЗавершена = Ложь;
	КонецЕсли;
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре Справочник.ПравилаПроверкиУчета.ОбработатьДанныеДляПереходаНаНовуюВерсию не удалось обработать некоторые записи проблемных объектов (пропущены): %1'"), 
			ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
		, ,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедура Справочник.ПравилаПроверкиУчета.ОбработатьДанныеДляПереходаНаНовуюВерсию обработала очередную порцию проблемных объектов: %1'"),
			ОбъектовОбработано));
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли