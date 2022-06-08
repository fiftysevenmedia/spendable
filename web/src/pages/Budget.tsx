import React from 'react';
import { useQuery } from '@apollo/client';
import { DateTime } from 'luxon'
import { useNavigate, useParams, useSearchParams } from "react-router-dom";

import { GET_BUDGET } from '../queries';
import { GetBudget } from '../graphql/GetBudget';
import formatCurrency from '../utils/formatCurrency';
import Row, { RowProps } from '../components/Row';
import TemplateRow, { TemplateRowItem } from '../components/TemplateRow';
import TransactionRow, { TransactionRowItem } from '../components/TransactionRow';

function Budget() {
  const { id } = useParams()
  const [searchParams] = useSearchParams()
  const monthFromSearchParams = searchParams.get("month")
  const activeMonth = monthFromSearchParams ? DateTime.fromFormat(monthFromSearchParams, 'yyyy-MM-dd') : DateTime.now().startOf('month')
  const navigate = useNavigate()

  const activeMonthIsCurrentMonth = DateTime.now().startOf('month').equals(activeMonth)

  const { data } = useQuery<GetBudget>(GET_BUDGET, {
    variables: {
      id: id,
      startDate: activeMonth.toFormat('yyyy-MM-dd'),
      endDate: activeMonth.endOf('month').toFormat('yyyy-MM-dd')
    }
  })

  if (!data) return null

  const balance = {
    key: 'balance',
    leftSide: 'Balance',
    rightSide: formatCurrency(data.budget.balance)
  }

  const spent = {
    key: 'spent',
    leftSide: 'Spent',
    rightSide: formatCurrency(data.budget.spent)
  }

  const detailLines: RowProps[] = []

  if (activeMonthIsCurrentMonth && !data.budget.trackSpendingOnly) detailLines.push(balance)
  detailLines.push(spent)

  const allocationTemplateLines: TemplateRowItem[] =
    [...data.budget.budgetAllocationTemplateLines]
      .sort((a, b) => b.amount.comparedTo(a.amount))
      .map(line => ({
        key: line.id,
        id: line.budgetAllocationTemplate.id,
        name: line.budgetAllocationTemplate.name,
        amount: line.amount,
        hideDelete: true,
        onClick: () => navigate(`/templates/${line.budgetAllocationTemplate.id}`)
      }))

  const recentAllocations: TransactionRowItem[] =
    [...data.budget.budgetAllocations]
      .sort((a, b) => b.transaction.date.getTime() - a.transaction.date.getTime())
      .map(allocation => ({
        key: allocation.id,
        id: allocation.transaction.id,
        name: allocation.transaction.name,
        amount: allocation.amount,
        date: allocation.transaction.date,
        reviewed: allocation.transaction.reviewed,
      }))

  return (
    <div className="flex flex-col items-center py-16">
      <div className="flex flex-col w-1/2">
        {detailLines.map(line => <Row {...line} />)}
      </div>

      <div className="flex flex-col w-1/2">
        {allocationTemplateLines.map(template => <TemplateRow {...template} />)}
      </div>

      <div className="flex flex-col w-1/2 py-16">
        {recentAllocations.map(transaction => <TransactionRow {...transaction} />)}
      </div>
    </div>
  )
}

export default Budget;