Функция ПолучитьПустуюСтруктуруНастроек() Экспорт
	
	//ИсходныеДанные = Новый ТаблицаЗначений;
	//ИсходныеДанные.Колонки.Добавить("Номенклатура",   Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	//ИсходныеДанные.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	//ИсходныеДанные.Колонки.Добавить("Упаковка",       Новый ОписаниеТипов("СправочникСсылка.УпаковкиНоменклатуры"));
	//ИсходныеДанные.Колонки.Добавить("Количество",     Новый ОписаниеТипов("Число"));
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ИсходныеДанные"     , Неопределено); // Таблица с произвольными данными
	СтруктураНастроек.Вставить("ОбязательныеПоля"   , Новый Массив); //
	СтруктураНастроек.Вставить("СоответствиеШаблоновИСтруктурыШаблонов" , Новый Соответствие); //
	СтруктураНастроек.Вставить("ПараметрыДанных"    , Новый Структура);
	СтруктураНастроек.Вставить("КомпоновщикНастроек", Неопределено); // Отбор
	СтруктураНастроек.Вставить("ИмяМакетаСхемыКомпоновкиДанных" , Неопределено);
	
	Возврат СтруктураНастроек;
	
КонецФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СтруктураНастроек = ПолучитьПустуюСтруктуруНастроек();
	СтруктураНастроек.ОбязательныеПоля.Добавить("КоличествоДляПечати");
	СтруктураНастроек.ОбязательныеПоля.Добавить("ШаблонДляПечати");
	СтруктураНастроек.ОбязательныеПоля.Добавить("Элемент");
		
	// Собираем используемые поля из шаблонов.
	ТаблицаШаблонов = МассивОбъектов[0].Элементы.Выгрузить(, "Шаблон");
	СоответствиеШаблонов = Новый Соответствие;
	
	//Если КоллекцияПечатныхФорм.Количество() > 0 Тогда
	//	ПечататьЦенники = КоллекцияПечатныхФорм[0].ИмяМакета = "Ценники";
	//	ПечататьЭтикетки = КоллекцияПечатныхФорм[0].ИмяМакета = "Этикетки";
	//КонецЕсли;
	//
	Для Каждого СтрокаТЧ Из ТаблицаШаблонов Цикл
		Если ЗначениеЗаполнено(СтрокаТЧ.Шаблон) Тогда
			СоответствиеШаблонов.Вставить(СтрокаТЧ.Шаблон);
		КонецЕсли;
	КонецЦикла;
	//
	//// Заполняем коллекцию обязательных полей и формируем соответствие шаблонов.
	Для Каждого КлючИЗначение ИЗ СоответствиеШаблонов Цикл
		СтруктураШаблона = КлючИЗначение.Ключ.Шаблон.Получить();
		
		// Структура шаблонов.
		СтруктураНастроек.СоответствиеШаблоновИСтруктурыШаблонов.Вставить(КлючИЗначение.Ключ, СтруктураШаблона);
		
		// Добавляем в массив обязательных полей поля, присутствующие в печатной форме ценника.
		Если СтруктураШаблона <> Неопределено
			И ТипЗнч(СтруктураШаблона) = Тип("Структура")
			И СтруктураШаблона.Свойство("ПараметрыШаблона") Тогда
			Для Каждого Элемент Из СтруктураШаблона.ПараметрыШаблона Цикл
				СтруктураНастроек.ОбязательныеПоля.Добавить(Элемент.Ключ);
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	//
	//// Подготовка исходных данных.
	ИсходныеДанные = МассивОбъектов[0].Элементы.Выгрузить(, "Ссылка, Количество, Шаблон,Штрихкод,Описание,ТипЭ");
	Для Каждого СтрокаТЧ Из ИсходныеДанные Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаТЧ.Шаблон) Тогда
			СтрокаТЧ.Количество = 0;
		КонецЕсли;
	КонецЦикла;
	//Если ПараметрыПечати.Режим = "ПечатьЭтикеток" Тогда
	//	ИсходныеДанные.ЗаполнитьЗначения(0,"КоличествоЦенников");
	//КонецЕсли;
	//Если ПараметрыПечати.Режим = "ПечатьЦенников" Тогда
	//	ИсходныеДанные.ЗаполнитьЗначения(0,"КоличествоЭтикеток");
	//КонецЕсли;
	//
	//СтруктураНастроек.ПараметрыДанных.Вставить("ВидЦены",     МассивОбъектов[0].ВидЦены);
	//СтруктураНастроек.ПараметрыДанных.Вставить("Магазин", МассивОбъектов[0].Магазин);
	//СтруктураНастроек.ПараметрыДанных.Вставить("ПравилоЦенообразования", МассивОбъектов[0].ПравилоЦенообразования);
	//СтруктураНастроек.ПараметрыДанных.Вставить("МагазинДляЦен", МассивОбъектов[0].Магазин);
	//СтруктураНастроек.ПараметрыДанных.Вставить("ЦеныПоВидуЦены", МассивОбъектов[0].ЦеныПоВидуЦены);
	//СтруктураНастроек.ПараметрыДанных.Вставить("ЦеныНаДату", МассивОбъектов[0].ЦеныНаДату);
	//СтруктураНастроек.ПараметрыДанных.Вставить("ЦеныНазначенныеДействующие", МассивОбъектов[0].ЦеныНазначенныеДействующие);
	////ВидМинимальныхЦенПродажи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(МассивОбъектов[0].Магазин, "ВидМинимальныхЦенПродажи");
	////СтруктураНастроек.ПараметрыДанных.Вставить("ВидЦеныМинимальной", ВидМинимальныхЦенПродажи);
	////СтруктураНастроек.ПараметрыДанных.Вставить("ЦеныМинимальные", ЗначениеЗаполнено(ВидМинимальныхЦенПродажи));
	//СтруктураНастроек.ПараметрыДанных.Вставить("ВидМинимальныхЦенПродажи", МассивОбъектов[0].ВидМинимальныхЦенПродажи);
	//СтруктураНастроек.ПараметрыДанных.Вставить("ЦеныМинимальные", МассивОбъектов[0].УчитыватьЦеныМинимальные);
	//
	//
	СтруктураНастроек.ИсходныеДанные = ИсходныеДанные;
	//
	//// Вывод табличных документов в коллекцию.
	КоллекцияПечатныхФормВнутренняя = СформироватьПечатныеФормыЭтикетокИЦенников(СтруктураНастроек);
	КоллекцияПечатныхФорм.Очистить();
	Для Каждого ПечатнаяФорма Из КоллекцияПечатныхФормВнутренняя Цикл
		
		НоваяФорма = КоллекцияПечатныхФорм.Добавить();
		НоваяФорма.ИмяМакета         = ПечатнаяФорма.ИмяМакета;
		НоваяФорма.СинонимМакета     = ПечатнаяФорма.ИмяМакета;
		НоваяФорма.ИмяВРЕГ           = ВРег(ПечатнаяФорма.ИмяМакета);
		НоваяФорма.ТабличныйДокумент = ПечатнаяФорма.ТабличныйДокумент;
		НоваяФорма.Экземпляров       = 1;
		
	КонецЦикла;
	
КонецПроцедуры


// Функция формирует табличный документ с ценниками и этикетками.
//
// Возвращаемое значение:
//  Табличный документ - печатная форма с ценниками и этикетками.
//
Функция СформироватьПечатныеФормыЭтикетокИЦенников(СтруктураНастроек)
	
	СтруктураРезультата = ПодготовитьСтруктуруДанных(СтруктураНастроек);
	
	Эталон = Обработки.ПечатьСправочников.ПолучитьМакет("Эталон");
	КоличествоМиллиметровВПикселе = Эталон.Рисунки.Квадрат100Пикселей.Высота / 100;
	
	// Подготовка коллекции печатных форм.
	КоллекцияПечатныхФорм = Новый ТаблицаЗначений;
	КоллекцияПечатныхФорм.Колонки.Добавить("ИмяМакета");
	КоллекцияПечатныхФорм.Колонки.Добавить("ТабличныйДокумент");
	КоллекцияПечатныхФорм.Колонки.Добавить("ИмяКолонкиКоличество");
	КоллекцияПечатныхФорм.Колонки.Добавить("ИмяКолонкиШаблон");
	КоллекцияПечатныхФорм.Колонки.Добавить("Шаблон");
	
	Для Каждого КлючИЗначение Из СтруктураНастроек.СоответствиеШаблоновИСтруктурыШаблонов Цикл
		ПечатнаяФорма = КоллекцияПечатныхФорм.Добавить();
		ПечатнаяФорма.ИмяМакета            = "Этикетка: "+КлючИЗначение.Ключ;
		ПечатнаяФорма.ИмяКолонкиКоличество = "Количество";
		ПечатнаяФорма.ИмяКолонкиШаблон     = "Шаблон";
		ПечатнаяФорма.Шаблон = КлючИЗначение.Ключ;
	КонецЦикла;
	
	Для Каждого ПечатнаяФорма Из КоллекцияПечатныхФорм Цикл
		
		НомерКолонки = 0;
		НомерРяда = 0;
		
		Для Каждого СтрокаТовары Из СтруктураРезультата.ТаблицаТоваров Цикл
			
			Если СтрокаТовары[ПечатнаяФорма.ИмяКолонкиКоличество] > 0 И СтрокаТовары[ПечатнаяФорма.ИмяКолонкиШаблон] = ПечатнаяФорма.Шаблон Тогда
				
				СтруктураШаблона = СтруктураНастроек.СоответствиеШаблоновИСтруктурыШаблонов.Получить(СтрокаТовары[ПечатнаяФорма.ИмяКолонкиШаблон]);
				
				Если ПечатнаяФорма.ТабличныйДокумент = Неопределено Тогда
					ПечатнаяФорма.ТабличныйДокумент = Новый ТабличныйДокумент;
				КонецЕсли;
				
				Если СтруктураШаблона <> Неопределено 
					И ТипЗнч(СтруктураШаблона) = Тип("Структура") Тогда
					
					Область = СтруктураШаблона.МакетЭтикетки.ПолучитьОбласть(СтруктураШаблона.ИмяОбластиПечати);
					
					// Применение настроек табличного документа.
					ЗаполнитьЗначенияСвойств(ПечатнаяФорма.ТабличныйДокумент, СтруктураШаблона.МакетЭтикетки, , "ОбластьПечати");
					
					Для каждого ПараметрШаблона Из СтруктураШаблона.ПараметрыШаблона Цикл
						Если ЕстьРеквизитОбъекта(Область.Параметры, ПараметрШаблона.Значение) Тогда
							НаименованиеКолонки = СтруктураРезультата.СоответствиеПолейСКДКолонкамТаблицыТоваров.Получить(Справочники.ХранилищеШаблонов.ИмяПоляВШаблоне(ПараметрШаблона.Ключ));
							НаименованиеКолонки=Справочники.ХранилищеШаблонов.ИмяПоляВШаблоне(ПараметрШаблона.Ключ);
							Если НаименованиеКолонки <> Неопределено Тогда
								//служебные поля
								Если ВРег(НаименованиеКолонки) = ВРег("ТекущееВремя") Тогда
									Область.Параметры[ПараметрШаблона.Значение] = Формат(СтрокаТовары[НаименованиеКолонки],"ДФ=dd.MM.yyyy");
								Иначе	
									Область.Параметры[ПараметрШаблона.Значение] = Вычислить("СтрокаТовары."+НаименованиеКолонки);
								КонецЕсли;
							КонецЕсли;
						КонецЕсли;
					КонецЦикла;
					
					Для каждого Рисунок Из Область.Рисунки Цикл
						Если Лев(Рисунок.Имя,8) = ПолучитьИмяПараметраШтрихкод() Тогда
							
							ЗначениеШтрихкода = СтрокаТовары[СтруктураРезультата.СоответствиеПолейСКДКолонкамТаблицыТоваров.Получить(ПолучитьИмяПараметраШтрихкод())];
							Если ЗначениеЗаполнено(ЗначениеШтрихкода) Тогда
								
								//ПараметрыШтрихкода = Новый Структура;
								//ПараметрыШтрихкода.Вставить("Ширина",          Окр(Рисунок.Ширина / КоличествоМиллиметровВПикселе));
								//ПараметрыШтрихкода.Вставить("Высота",          Окр(Рисунок.Высота / КоличествоМиллиметровВПикселе));
								//ПараметрыШтрихкода.Вставить("Штрихкод",        ЗначениеШтрихкода);
								//ПараметрыШтрихкода.Вставить("ТипКода",         СтруктураШаблона.ТипКода);
								//ПараметрыШтрихкода.Вставить("ОтображатьТекст", СтруктураШаблона.ОтображатьТекст);
								//ПараметрыШтрихкода.Вставить("РазмерШрифта",    СтруктураШаблона.РазмерШрифта);
								//Если СтруктураШаблона.Свойство("УголПоворота") Тогда
								//	ПараметрыШтрихкода.Вставить("УголПоворота", СтруктураШаблона.УголПоворота);
								//КонецЕсли;
								
								ПараметрыШтрихкода			= Документы.ВыдачаТранзита.ЗаполнитьПараметрыОбработки(ЗначениеШтрихкода);

								Рисунок.Картинка = МенеджерОборудованияВызовСервера.ПолучитьКартинкуШтрихкода(ПараметрыШтрихкода);
								
							КонецЕсли;
							
						КонецЕсли;
					КонецЦикла;
					
					Для Инд = 1 По СтрокаТовары[ПечатнаяФорма.ИмяКолонкиКоличество] Цикл // Цикл по количеству экземпляров
						
						НомерКолонки = НомерКолонки + 1;
						
						Если НомерКолонки = 1 Тогда
							
							НомерРяда = НомерРяда + 1;
							
							ПечатнаяФорма.ТабличныйДокумент.Вывести(Область);
							
						Иначе
							
							ПечатнаяФорма.ТабличныйДокумент.Присоединить(Область);
							
						КонецЕсли;
						
						Если НомерКолонки = СтруктураШаблона.КоличествоПоГоризонтали И НомерРяда = СтруктураШаблона.КоличествоПоВертикали Тогда
							
							НомерРяда    = 0;
							НомерКолонки = 0;
							
							ПечатнаяФорма.ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
							
						ИначеЕсли НомерКолонки = СтруктураШаблона.КоличествоПоГоризонтали Тогда
							
							НомерКолонки = 0;
							
						КонецЕсли;
						
					КонецЦикла; // Цикл по количеству экземпляров
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла; // Цикл по строкам таблицы товаров
		
	КонецЦикла;
	
	МассивСтрокДляУдаления = Новый Массив;
	Для Каждого ПечатнаяФорма Из КоллекцияПечатныхФорм Цикл
		Если ПечатнаяФорма.ТабличныйДокумент = Неопределено Тогда
			МассивСтрокДляУдаления.Добавить(ПечатнаяФорма);
		КонецЕсли;
	КонецЦикла;
	Для Каждого ПечатнаяФорма Из МассивСтрокДляУдаления Цикл
		КоллекцияПечатныхФорм.Удалить(ПечатнаяФорма);
	КонецЦикла;
	
	Возврат КоллекцияПечатныхФорм;
	
КонецФункции

// Функция подготавливает структуру данных, необходимую для печати ценников и этикеток.
//
// Возвращаемое значение:
//  Стрруктура - данные, необходимые для печати этикеток и ценников.
//
Функция ПодготовитьСтруктуруДанных(СтруктураНастроек) Экспорт
	
	СтруктураРезультата = ПолучитьПустуюСтруктуруРезультата();
	
	
	// Схема компоновки.
	СхемаКомпоновкиДанных = Обработки.ПечатьСправочников.ПолучитьМакет(СтруктураНастроек.ИмяМакетаСхемыКомпоновкиДанных);
	
	// Подготовка компоновщика макета компоновки данных.
	Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	Компоновщик.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	Компоновщик.Настройки.Отбор.Элементы.Очистить();
		
	// Отбор компоновщика настроек.
	Если СтруктураНастроек.КомпоновщикНастроек <> Неопределено Тогда
		//удаление невалидных отборов
		Количество = СтруктураНастроек.КомпоновщикНастроек.Настройки.Отбор.Элементы.Количество();
		Для Индекс = 1 По Количество Цикл
			ЭлементОтбора = СтруктураНастроек.КомпоновщикНастроек.Настройки.Отбор.Элементы[Количество - Индекс];
			ПолеОтбора = ЭлементОтбора.ЛевоеЗначение;
			Если СтруктураНастроек.КомпоновщикНастроек.Настройки.Отбор.ДоступныеПоляОтбора.НайтиПоле(ПолеОтбора) = Неопределено Тогда
				СтруктураНастроек.КомпоновщикНастроек.Настройки.Отбор.Элементы.Удалить(ЭлементОтбора);
			КонецЕсли;
		КонецЦикла;		
		СкопироватьЭлементы(Компоновщик.Настройки.Отбор, СтруктураНастроек.КомпоновщикНастроек.Настройки.Отбор);
		
	КонецЕсли;
	
	// Выбранные поля компоновщика настроек.
	Для Каждого ОбязательноеПоле Из СтруктураНастроек.ОбязательныеПоля Цикл
		ПолеСКД = УправлениеШаблонами.НайтиПолеСКДПоПолномуИмени(Компоновщик.Настройки.Выбор.ДоступныеПоляВыбора.Элементы, ОбязательноеПоле);
		Если ПолеСКД <> Неопределено Тогда
			ВыбранноеПоле = Компоновщик.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ВыбранноеПоле.Поле = ПолеСКД.Поле;
		КонецЕсли;
	КонецЦикла;
	
	// Заполнение параметров.
	Для Каждого ПараметрДанных Из СтруктураНастроек.ПараметрыДанных Цикл
		Если ПараметрДанных.Ключ = "Склад" Тогда // Если склад не заполнен - не используем параметр
			УстановитьЗначениеПараметраСКД(Компоновщик, ПараметрДанных.Ключ, ПараметрДанных.Значение, Ложь);
		Иначе
			УстановитьЗначениеПараметраСКД(Компоновщик, ПараметрДанных.Ключ, ПараметрДанных.Значение);
		КонецЕсли;
	КонецЦикла;
	УстановитьЗначениеПараметраСКД(Компоновщик, "ТекущееВремя",        ТекущаяДата());
	УстановитьЗначениеПараметраСКД(Компоновщик, "ТекущийПользователь", Пользователи.ТекущийПользователь());
	
	// Компоновка макета компоновки данных.
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Компоновщик.Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	
	Для каждого Поле Из МакетКомпоновкиДанных.НаборыДанных.НаборДанных.Поля Цикл
		СтруктураРезультата.СоответствиеПолейСКДКолонкамТаблицыТоваров.Вставить(Справочники.ХранилищеШаблонов.ИмяПоляВШаблоне(Поле.ПутьКДанным), Поле.Имя);
	КонецЦикла;
	
	
	Запрос = Новый Запрос(МакетКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос);
	
	// Заполнение параметров с полей отбора компоновщика настроек формы обработки.
	Для каждого Параметр Из МакетКомпоновкиДанных.ЗначенияПараметров Цикл
		Запрос.Параметры.Вставить(Параметр.Имя, Параметр.Значение);
	КонецЦикла;
	
	
	// Подмена запроса для расчета цен...
	//Если ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры") Тогда

	//	ЗаменяемыйТекст = "ЦеныНоменклатурыСрезПоследних.Цена";
	//	ТекстЗамены = " ВЫРАЗИТЬ(
	//				  |          ЦеныНоменклатурыСрезПоследних.Цена
	//				  |          / 
	//				  |          ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Упаковка.Коэффициент, 1) 
	//				  |          * 
	//				  |          ЕСТЬNULL(ИсходныеДанныеПоследнийЗапрос.Упаковка.Коэффициент, 1) КАК Число(15,2)) ";
	//	Запрос.Текст = СтрЗаменить(Запрос.Текст, ЗаменяемыйТекст, ТекстЗамены);
	//	
	//КонецЕсли;
	
	// Подмена запроса при печати этикеток...
	Если СтруктураНастроек.ИсходныеДанные <> Неопределено Тогда
		
		//ТекстВременнойТаблицы =
		//"	(ВЫБРАТЬ
		//|		ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) КАК Номенклатура,
		//|		ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК Характеристика,
		//|		ЗНАЧЕНИЕ(Справочник.УпаковкиНоменклатуры.ПустаяСсылка) КАК Упаковка,
		//|		0 КАК Количество,
		//|		ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка) КАК Организация)";
		//
		//Запрос.Текст = СтрЗаменить(Запрос.Текст, ТекстВременнойТаблицы, "&Таблица");
		//Запрос.Параметры.Вставить("Таблица", СтруктураНастроек.ИсходныеДанные);
		//
		//Запрос.Текст = СтрЗаменить(Запрос.Текст, """КоличествоЦенников""", "ИсходныеДанные.КоличествоЦенников");
		//Запрос.Текст = СтрЗаменить(Запрос.Текст, """КоличествоЭтикеток""", "ИсходныеДанные.КоличествоЭтикеток");
		//Запрос.Текст = СтрЗаменить(Запрос.Текст, """ШаблонЦенника""", "ИсходныеДанные.ШаблонЦенника");
		//Запрос.Текст = СтрЗаменить(Запрос.Текст, """ШаблонЭтикетки""", "ИсходныеДанные.ШаблонЭтикетки");
		//Запрос.Текст = СтрЗаменить(Запрос.Текст, """Организация""", "ИсходныеДанные.Организация");
		СтруктураРезультата.ТаблицаТоваров=СтруктураНастроек.ИсходныеДанные;
	Иначе	
		СтруктураРезультата.ТаблицаТоваров = Запрос.Выполнить().Выгрузить();
	
		
	КонецЕсли;
	
	
		
	Возврат СтруктураРезультата;
	
КонецФункции

// Функция определяет существует ли реквизит у формы.
//
Функция ЕстьРеквизитОбъекта(Объект, ИмяРеквизита)
	
	КлючУникальности   = Новый УникальныйИдентификатор;

	СтруктураРеквизита = Новый Структура(ИмяРеквизита, КлючУникальности);

	ЗаполнитьЗначенияСвойств(СтруктураРеквизита, Объект);
	
	Возврат СтруктураРеквизита[ИмяРеквизита] <> КлючУникальности;
	
КонецФункции

Функция ПолучитьИмяПараметраШтрихкод()
	
	Возврат "Штрихкод";
	
КонецФункции

Функция ПолучитьПустуюСтруктуруРезультата() Экспорт
	
	Структура = Новый Структура;
	Структура.Вставить("ТаблицаТоваров" , Неопределено);
	Структура.Вставить("СоответствиеПолейСКДКолонкамТаблицыТоваров", Новый Соответствие);
	
	Возврат Структура;
	
КонецФункции

Функция УстановитьЗначениеПараметраСКД(КомпоновщикНастроек, ИмяПараметра, ЗначениеПараметра, ИспользоватьНеЗаполненный = Истина)
	
	ПараметрУстановлен = Ложь;
	
	ПараметрВидЦены = Новый ПараметрКомпоновкиДанных(ИмяПараметра);
	ЗначениеПараметраВидЦены = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПараметрВидЦены);
	Если ЗначениеПараметраВидЦены <> Неопределено Тогда
		
		ЗначениеПараметраВидЦены.Значение = ЗначениеПараметра;
		ЗначениеПараметраВидЦены.Использование = ?(ИспользоватьНеЗаполненный, Истина, ЗначениеЗаполнено(ЗначениеПараметраВидЦены.Значение));
		
		ПараметрУстановлен = Истина;
		
	КонецЕсли;
	
	Возврат ПараметрУстановлен;
	
КонецФункции



#Область ОбщегоНазначенияУТКлиентСервер


// Копирует элементы из одной коллекции в другую
Процедура СкопироватьЭлементы(ПриемникЗначения, ИсточникЗначения, ПроверятьДоступность = Ложь, ОчищатьПриемник = Истина) Экспорт
	
	Если ТипЗнч(ИсточникЗначения) = Тип("УсловноеОформлениеКомпоновкиДанных")
		ИЛИ ТипЗнч(ИсточникЗначения) = Тип("ВариантыПользовательскогоПоляВыборКомпоновкиДанных")
		ИЛИ ТипЗнч(ИсточникЗначения) = Тип("ОформляемыеПоляКомпоновкиДанных")
		ИЛИ ТипЗнч(ИсточникЗначения) = Тип("ЗначенияПараметровДанныхКомпоновкиДанных") Тогда
		СоздаватьПоТипу = Ложь;
	Иначе
		СоздаватьПоТипу = Истина;
	КонецЕсли;
	ПриемникЭлементов = ПриемникЗначения.Элементы;
	ИсточникЭлементов = ИсточникЗначения.Элементы;
	Если ОчищатьПриемник Тогда
		ПриемникЭлементов.Очистить();
	КонецЕсли;
	
	Для каждого ЭлементИсточник Из ИсточникЭлементов Цикл
		
		Если ТипЗнч(ЭлементИсточник) = Тип("ЭлементПорядкаКомпоновкиДанных") Тогда
			// Элементы порядка добавляем в начало
			Индекс = ИсточникЭлементов.Индекс(ЭлементИсточник);
			ЭлементПриемник = ПриемникЭлементов.Вставить(Индекс, ТипЗнч(ЭлементИсточник));
		Иначе
			Если СоздаватьПоТипу Тогда
				ЭлементПриемник = ПриемникЭлементов.Добавить(ТипЗнч(ЭлементИсточник));
			Иначе
				ЭлементПриемник = ПриемникЭлементов.Добавить();
			КонецЕсли;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭлементПриемник, ЭлементИсточник);
		// В некоторых коллекциях необходимо заполнить другие коллекции
		Если ТипЗнч(ИсточникЭлементов) = Тип("КоллекцияЭлементовУсловногоОформленияКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник.Поля, ЭлементИсточник.Поля);
			СкопироватьЭлементы(ЭлементПриемник.Отбор, ЭлементИсточник.Отбор);
			ЗаполнитьЭлементы(ЭлементПриемник.Оформление, ЭлементИсточник.Оформление); 
		ИначеЕсли ТипЗнч(ИсточникЭлементов)	= Тип("КоллекцияВариантовПользовательскогоПоляВыборКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник.Отбор, ЭлементИсточник.Отбор);
		КонецЕсли;
		
		// В некоторых элементах коллекции необходимо заполнить другие коллекции
		Если ТипЗнч(ЭлементИсточник) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник, ЭлементИсточник);
		ИначеЕсли ТипЗнч(ЭлементИсточник) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник, ЭлементИсточник);
		ИначеЕсли ТипЗнч(ЭлементИсточник) = Тип("ПользовательскоеПолеВыборКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник.Варианты, ЭлементИсточник.Варианты);
		ИначеЕсли ТипЗнч(ЭлементИсточник) = Тип("ПользовательскоеПолеВыражениеКомпоновкиДанных") Тогда
			ЭлементПриемник.УстановитьВыражениеДетальныхЗаписей (ЭлементИсточник.ПолучитьВыражениеДетальныхЗаписей());
			ЭлементПриемник.УстановитьВыражениеИтоговыхЗаписей(ЭлементИсточник.ПолучитьВыражениеИтоговыхЗаписей());
			ЭлементПриемник.УстановитьПредставлениеВыраженияДетальныхЗаписей(ЭлементИсточник.ПолучитьПредставлениеВыраженияДетальныхЗаписей ());
			ЭлементПриемник.УстановитьПредставлениеВыраженияИтоговыхЗаписей(ЭлементИсточник.ПолучитьПредставлениеВыраженияИтоговыхЗаписей ());
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры


Процедура ЗаполнитьЭлементы(ПриемникЗначения, ИсточникЗначения, ПервыйУровень = Неопределено) Экспорт
	
	Если ТипЗнч(ПриемникЗначения) = Тип("КоллекцияЗначенийПараметровКомпоновкиДанных") Тогда
		КоллекцияЗначений = ИсточникЗначения;
	Иначе
		КоллекцияЗначений = ИсточникЗначения.Элементы;
	КонецЕсли;
	
	Для каждого ЭлементИсточник Из КоллекцияЗначений Цикл
		Если ПервыйУровень = Неопределено Тогда
			ЭлементПриемник = ПриемникЗначения.НайтиЗначениеПараметра(ЭлементИсточник.Параметр);
		Иначе
			ЭлементПриемник = ПервыйУровень.НайтиЗначениеПараметра(ЭлементИсточник.Параметр);
		КонецЕсли;
		Если ЭлементПриемник = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭлементПриемник, ЭлементИсточник);
		Если ТипЗнч(ЭлементИсточник) = Тип("ЗначениеПараметраКомпоновкиДанных") Тогда
			Если ЭлементИсточник.ЗначенияВложенныхПараметров.Количество() <> 0 Тогда
				ЗаполнитьЭлементы(ЭлементПриемник.ЗначенияВложенныхПараметров, ЭлементИсточник.ЗначенияВложенныхПараметров, ПриемникЗначения);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры




#КонецОбласти



