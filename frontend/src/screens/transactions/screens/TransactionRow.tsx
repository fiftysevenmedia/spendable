import React, { useRef } from 'react'
import {
  Text,
  TouchableHighlight,
  View
} from 'react-native'
import { useNavigation } from '@react-navigation/native'
import { RectButton } from 'react-native-gesture-handler'
import Swipeable from 'react-native-gesture-handler/Swipeable'
import { useMutation } from '@apollo/client'
import { useTheme } from '@react-navigation/native'
import { Ionicons } from '@expo/vector-icons'
import formatCurrency from 'src/utils/formatCurrency'
import AppStyles from 'src/utils/useAppStyles'
import { ListTransactions_transactions } from '../graphql/ListTransactions'
import { DELETE_TRANSACTION } from '../queries'
import { DateTime } from 'luxon'
import { LIST_BUDGETS } from 'src/screens/budgets/queries'
import { GET_SPENDABLE } from 'src/screens/headers/spendable-header/queries'

type Props = {
  transaction: ListTransactions_transactions,
}

export default function TransactionRow({ transaction }: Props) {
  const navigation = useNavigation()
  const { colors }: any = useTheme()
  const { styles, fontSize } = AppStyles()

  const navigateToTransaction = () => navigation.navigate('Transaction', { transactionId: transaction.id })

  const [deleteTransaction] = useMutation(DELETE_TRANSACTION, {
    variables: { id: transaction.id },
    refetchQueries: [{ query: LIST_BUDGETS }, { query: GET_SPENDABLE }],
    update(cache, { data: { deleteTransaction } }) {
      cache.evict({ id: 'Transaction:' + deleteTransaction.id })
      cache.gc()
    }
  })

  const renderRightActions = () => {
    return (
      <RectButton style={styles.deleteButton}>
        <Text style={styles.deleteButtonText}>Delete</Text>
      </RectButton>
    )
  }

  return (
    <TouchableHighlight onPress={navigateToTransaction}>
      <Swipeable
        renderRightActions={renderRightActions}
        onSwipeableOpen={() => {
          deleteTransaction()
        }}
      >
        <View style={styles.row}>
          <View style={{ flex: 1 }}>
            <Text numberOfLines={1} style={{ ...styles.text, ...{ paddingRight: 8 } }}>
              {transaction.name}
            </Text>
            <Text style={styles.secondaryText}>
              {DateTime.fromJSDate(transaction.date).toLocaleString(DateTime.DATE_MED)}
            </Text>
          </View>

          <View style={{ flexDirection: "row" }}>
            <Text
              style={{
                color: transaction.amount.isNegative() ? 'red' : colors.secondary,
                fontSize: fontSize,
                paddingRight: 8
              }}
            >
              {formatCurrency(transaction.amount)}
            </Text>
            {transaction.reviewed ?
              <Ionicons name='checkmark-circle-outline' size={fontSize} color={colors.secondary} /> : null
            }
            <Ionicons name='chevron-forward-outline' size={fontSize} color={colors.secondary} />
          </View>
        </View>
      </Swipeable>
    </TouchableHighlight>
  )
}