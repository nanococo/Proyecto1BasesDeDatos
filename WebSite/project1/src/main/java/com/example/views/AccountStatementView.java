package com.example.views;

import com.example.pojos.Statement;
import com.example.services.Services;
import com.example.services.singletons.Common;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.dependency.CssImport;
import com.vaadin.flow.component.grid.Grid;
import com.vaadin.flow.component.grid.GridVariant;
import com.vaadin.flow.component.html.H1;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.router.Route;
import org.springframework.beans.factory.annotation.Autowired;

@Route(value = "statement")
@CssImport("./styles/shared-styles.css")
public class AccountStatementView extends VerticalLayout {

    private final Grid<Statement> dataGrid = new Grid<>(Statement.class);

    private final Services services;

    private final Button viewMovements = new Button("Movimientos");

    public AccountStatementView(@Autowired Services services) {
        this.services = services;

        H1 h1 = new H1("Estado de Cuenta");
        HorizontalLayout horizontalLayout = new HorizontalLayout(viewMovements);

        configureViewMovementsButton();
        configureDataGrid();
        setSizeFull();
        add(h1, horizontalLayout, dataGrid);
    }

    private void configureViewMovementsButton() {
        viewMovements.setEnabled(false);
        viewMovements.addClickListener(buttonClickEvent -> {
            services.navigateToMovements();
        });
    }


    private void configureDataGrid() {
        dataGrid.setItems(services.getStatements());
        dataGrid.setSizeFull();
        dataGrid.setSelectionMode(Grid.SelectionMode.SINGLE);
        dataGrid.addThemeVariants(GridVariant.LUMO_ROW_STRIPES, GridVariant.MATERIAL_COLUMN_DIVIDERS);
        dataGrid.setVerticalScrollingEnabled(true);
        dataGrid.setColumnOrder(dataGrid.getColumnByKey("statementId"), dataGrid.getColumnByKey("accountId"), dataGrid.getColumnByKey("initialBalance"), dataGrid.getColumnByKey("endBalance"), dataGrid.getColumnByKey("startDate"), dataGrid.getColumnByKey("endDate"));
        dataGrid.getColumns().forEach(col -> col.setAutoWidth(true));
        dataGrid.asSingleSelect().addValueChangeListener(event -> {
            Common.startDate = event.getValue().getStartDate();
            Common.endDate = event.getValue().getEndDate();
            viewMovements.setEnabled(true);
        });
    }
}
