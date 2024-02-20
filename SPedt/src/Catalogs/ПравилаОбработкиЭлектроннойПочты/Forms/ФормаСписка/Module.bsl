
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.Отбор.Свойство("Владелец") Тогда
		
		Если НЕ Взаимодействия.ПользовательЯвляетсяОтветственнымЗаВедениеПапок(Параметры.Отбор.Владелец) Тогда
			
			ТолькоПросмотр = Истина;
			
			Элементы.ФормаКоманднаяПанель.ПодчиненныеЭлементы.ФормаПрименитьПравила.Видимость               = Ложь;
			Элементы.НастройкаПорядкаЭлементов.Видимость = Ложь;
			
		КонецЕсли;
		
	Иначе
		
		Отказ = Истина;
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПрименитьПравила(Команда)
	
	ОчиститьСообщения();
	
	ПараметрыФормы = Новый Структура;
	
	МассивЭлементовОтбора = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(ВзаимодействияКлиентСервер.ОтборДинамическогоСписка(Список), "Владелец");
	Если МассивЭлементовОтбора.Количество() > 0 И МассивЭлементовОтбора[0].Использование
		И ЗначениеЗаполнено(МассивЭлементовОтбора[0].ПравоеЗначение) Тогда
		ПараметрыФормы.Вставить("УчетнаяЗапись",МассивЭлементовОтбора[0].ПравоеЗначение);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не установлен отбор по владельцу(учетной записи) правил.'"));
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ПравилаОбработкиЭлектроннойПочты.Форма.ПрименениеПравил", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
